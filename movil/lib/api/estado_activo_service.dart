// lib/api/estado_activo_service.dart

import 'dart:convert';
import '../models/estado_activo.dart';
import 'api_client.dart';

class EstadoActivoService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'estados/';

  Future<List<EstadoActivo>> getItems() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => EstadoActivo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los estados de activos');
    }
  }

  Future<EstadoActivo> updateItem(int id, EstadoActivo item) async {
    final response = await _apiClient.put('$_endpoint$id/', item.toJson());
    if (response.statusCode == 200) {
      return EstadoActivo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al actualizar el estado');
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el estado');
    }
  }
}