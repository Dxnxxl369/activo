// lib/api/empresa_service.dart

import 'dart:convert';
import '../models/empresa.dart';
import 'api_client.dart';

class EmpresaService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'empresas/';

  Future<List<Empresa>> getItems() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Empresa.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las empresas');
    }
  }
}