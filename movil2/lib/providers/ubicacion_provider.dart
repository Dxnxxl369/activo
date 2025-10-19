// lib/providers/ubicacion_provider.dart

import 'package:flutter/foundation.dart';
import '../models/ubicacion.dart';
import '../api/ubicacion_service.dart';

class UbicacionProvider with ChangeNotifier {
  final UbicacionService _service = UbicacionService();
  List<Ubicacion> _items = [];
  bool _isLoading = false;

  List<Ubicacion> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _service.getItems();
    } catch (e) {
      debugPrint("Error en provider de ubicaciones: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateItem(Ubicacion item) async {
    try {
      final updated = await _service.updateItem(item.id, item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al actualizar ubicación: $e");
      rethrow;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _service.deleteItem(id);
      _items.removeWhere((i) => i.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error al eliminar ubicación: $e");
      rethrow;
    }
  }
}