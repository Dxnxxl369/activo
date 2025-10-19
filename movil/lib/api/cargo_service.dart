// lib/api/cargo_service.dart

import 'dart:convert';
import '../models/cargo.dart';
import 'api_client.dart';

class CargoService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'cargos/';

  Future<List<Cargo>> getCargos() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Cargo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar cargos');
    }
  }

  Future<Cargo> updateCargo(int id, Cargo cargo) async {
    final response = await _apiClient.put('$_endpoint$id/', cargo.toJson());
    if (response.statusCode == 200) {
      return Cargo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al actualizar cargo');
    }
  }

  Future<void> deleteCargo(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar cargo');
    }
  }
}