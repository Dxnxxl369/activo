// lib/api/proveedor_service.dart

import 'dart:convert';
import '../models/proveedor.dart';
import 'api_client.dart';

class ProveedorService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'proveedores/';

  // LEER todos los proveedores (solo los activos por defecto)
  Future<List<Proveedor>> getProveedores() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Proveedor.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los proveedores');
    }
  }

  // ACTUALIZAR un proveedor
  Future<Proveedor> updateProveedor(int id, Proveedor proveedor) async {
    final response = await _apiClient.put('$_endpoint$id/', proveedor.toJson());
    if (response.statusCode == 200) {
      return Proveedor.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al actualizar el proveedor');
    }
  }

  // BORRAR un proveedor (cambiar estado a inactivo)
  Future<void> deleteProveedor(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');
    // El backend responde 200 OK en este caso, no 204
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el proveedor');
    }
  }
}