// lib/api/activofijo_service.dart

import 'dart:convert';
import '../models/activo_fijo.dart';
import 'api_client.dart';

class ActivoFijoService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'activos-fijos/';

  Future<List<ActivoFijo>> getActivosFijos() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ActivoFijo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los activos fijos');
    }
  }

  Future<ActivoFijo> updateActivoFijo(int id, ActivoFijo activo) async {
    final response = await _apiClient.put('$_endpoint$id/', activo.toJson());
    if (response.statusCode == 200) {
      return ActivoFijo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al actualizar el activo fijo');
    }
  }

  Future<void> deleteActivoFijo(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el activo fijo');
    }
  }
}