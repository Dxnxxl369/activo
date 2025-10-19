// lib/api/departamento_service.dart

import 'dart:convert';
import '../models/departamento.dart';
import 'api_client.dart';

class DepartamentoService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'departamentos/';

  Future<List<Departamento>> getDepartamentos() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Departamento.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar departamentos');
    }
  }

  Future<Departamento> updateDepartamento(int id, Departamento depto) async {
    final response = await _apiClient.put('$_endpoint$id/', depto.toJson());
    if (response.statusCode == 200) {
      return Departamento.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al actualizar departamento');
    }
  }

  Future<void> deleteDepartamento(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar departamento');
    }
  }
}