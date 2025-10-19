// lib/providers/estado_activo_provider.dart

import 'package:flutter/foundation.dart';
import '../models/estado_activo.dart';
import '../api/estado_activo_service.dart';

class EstadoActivoProvider with ChangeNotifier {
  final EstadoActivoService _service = EstadoActivoService();
  List<EstadoActivo> _items = [];
  bool _isLoading = false;

  List<EstadoActivo> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _service.getItems();
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateItem(EstadoActivo item) async {
    try {
      final updated = await _service.updateItem(item.id, item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _service.deleteItem(id);
      _items.removeWhere((i) => i.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}