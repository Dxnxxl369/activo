// lib/providers/activofijo_provider.dart

import 'package:flutter/foundation.dart';
import '../models/activo_fijo.dart';
import '../api/activofijo_service.dart';

class ActivoFijoProvider with ChangeNotifier {
  final ActivoFijoService _activoFijoService = ActivoFijoService();
  List<ActivoFijo> _activos = [];
  bool _isLoading = false;

  List<ActivoFijo> get activos => _activos;
  bool get isLoading => _isLoading;

  Future<void> fetchActivosFijos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _activos = await _activoFijoService.getActivosFijos();
    } catch (error) {
      print("Error en provider: $error");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateActivoFijo(ActivoFijo activo) async {
    try {
      final updatedActivo = await _activoFijoService.updateActivoFijo(activo.id, activo);
      final index = _activos.indexWhere((a) => a.id == activo.id);
      if (index != -1) {
        _activos[index] = updatedActivo;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> deleteActivoFijo(int id) async {
    try {
      await _activoFijoService.deleteActivoFijo(id);
      _activos.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}