// lib/providers/empleado_provider.dart

import 'package:flutter/foundation.dart';
import '../models/empleado.dart';
import '../api/empleado_service.dart';

class EmpleadoProvider with ChangeNotifier {
  final EmpleadoService _service = EmpleadoService();
  List<Empleado> _empleados = [];
  bool _isLoading = false;

  List<Empleado> get empleados => _empleados;
  bool get isLoading => _isLoading;

  Future<void> fetchEmpleados() async {
    _isLoading = true;
    notifyListeners();
    try {
      _empleados = await _service.getEmpleados();
    } catch (error) {
      print("Error en provider de empleados: $error");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateEmpleado(Empleado empleado) async {
    try {
      final updated = await _service.updateEmpleado(empleado.id, empleado);
      final index = _empleados.indexWhere((e) => e.id == empleado.id);
      if (index != -1) {
        _empleados[index] = updated;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> deleteEmpleado(int id) async {
    try {
      await _service.deleteEmpleado(id);
      _empleados.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}