// lib/providers/presupuesto_provider.dart

import 'package:flutter/foundation.dart';
import '../models/presupuesto.dart';
import '../api/presupuesto_service.dart';

class PresupuestoProvider with ChangeNotifier {
  final PresupuestoService _presupuestoService = PresupuestoService();
  List<Presupuesto> _presupuestos = [];
  bool _isLoading = false;

  List<Presupuesto> get presupuestos => _presupuestos;
  bool get isLoading => _isLoading;

  Future<void> fetchPresupuestos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _presupuestos = await _presupuestoService.getPresupuestos();
    } catch (error) {
      // Aquí podrías manejar el error de forma más específica
      print(error);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updatePresupuesto(Presupuesto presupuesto) async {
    try {
      final updatedPresupuesto = await _presupuestoService.updatePresupuesto(presupuesto.id, presupuesto);
      final index = _presupuestos.indexWhere((p) => p.id == presupuesto.id);
      if (index != -1) {
        _presupuestos[index] = updatedPresupuesto;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error; // Lanza el error para que la UI pueda mostrar un mensaje
    }
  }

  Future<void> deletePresupuesto(int id) async {
    try {
      await _presupuestoService.deletePresupuesto(id);
      _presupuestos.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error; // Lanza el error para que la UI pueda mostrar un mensaje
    }
  }
}