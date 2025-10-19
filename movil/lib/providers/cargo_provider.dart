// lib/providers/cargo_provider.dart

import 'package:flutter/foundation.dart';
import '../models/cargo.dart';
import '../api/cargo_service.dart';

class CargoProvider with ChangeNotifier {
  final CargoService _service = CargoService();
  List<Cargo> _items = [];
  bool _isLoading = false;

  List<Cargo> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchCargos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _service.getCargos();
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCargo(Cargo cargo) async {
    try {
      final updated = await _service.updateCargo(cargo.id, cargo);
      final index = _items.indexWhere((c) => c.id == cargo.id);
      if (index != -1) {
        _items[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCargo(int id) async {
    try {
      await _service.deleteCargo(id);
      _items.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}