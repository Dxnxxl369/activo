// lib/providers/departamento_provider.dart

import 'package:flutter/foundation.dart';
import '../models/departamento.dart';
import '../api/departamento_service.dart';

class DepartamentoProvider with ChangeNotifier {
  final DepartamentoService _service = DepartamentoService();
  List<Departamento> _items = [];
  bool _isLoading = false;

  List<Departamento> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchDepartamentos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _service.getDepartamentos();
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateDepartamento(Departamento depto) async {
    try {
      final updated = await _service.updateDepartamento(depto.id, depto);
      final index = _items.indexWhere((d) => d.id == depto.id);
      if (index != -1) {
        _items[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDepartamento(int id) async {
    try {
      await _service.deleteDepartamento(id);
      _items.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}