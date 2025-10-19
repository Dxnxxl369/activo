// lib/api/categoria_activo_service.dart

import 'dart:convert';
import '../models/categoria_activo.dart';
import 'api_client.dart';

class CategoriaActivoService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'categorias-activos/';

  Future<List<CategoriaActivo>> getItems() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => CategoriaActivo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }

  Future<CategoriaActivo> updateItem(int id, CategoriaActivo item) async {
    final response = await _apiClient.put('$_endpoint$id/', item.toJson());
    if (response.statusCode == 200) {
      return CategoriaActivo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al actualizar categoría');
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar categoría');
    }
  }
}