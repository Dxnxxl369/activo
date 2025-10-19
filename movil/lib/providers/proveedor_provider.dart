// lib/providers/proveedor_provider.dart

import 'package:flutter/foundation.dart';
import '../models/proveedor.dart';
import '../api/proveedor_service.dart';

class ProveedorProvider with ChangeNotifier {
  final ProveedorService _proveedorService = ProveedorService();
  List<Proveedor> _proveedores = [];
  bool _isLoading = false;

  List<Proveedor> get proveedores => _proveedores;
  bool get isLoading => _isLoading;

  Future<void> fetchProveedores() async {
    _isLoading = true;
    notifyListeners();
    try {
      _proveedores = await _proveedorService.getProveedores();
    } catch (error) {
      print("Error en provider de proveedores: $error");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProveedor(Proveedor proveedor) async {
    try {
      final updatedProveedor = await _proveedorService.updateProveedor(proveedor.id, proveedor);
      final index = _proveedores.indexWhere((p) => p.id == proveedor.id);
      if (index != -1) {
        _proveedores[index] = updatedProveedor;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> deleteProveedor(int id) async {
    try {
      await _proveedorService.deleteProveedor(id);
      // En lugar de eliminarlo de la lista, lo filtramos para que desaparezca de la UI
      _proveedores.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}