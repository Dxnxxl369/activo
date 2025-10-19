// lib/api/rol_service.dart

import 'dart:convert';
import '../models/rol.dart';
import 'api_client.dart';

class RolService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'roles/';

  Future<List<Rol>> getRoles() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Rol.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los roles');
    }
  }
}