// lib/api/empleado_service.dart

import 'dart:convert';
import '../models/empleado.dart';
import 'api_client.dart';

class EmpleadoService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'empleados/';

  Future<List<Empleado>> getEmpleados() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Empleado.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los empleados');
    }
  }

  Future<Empleado> updateEmpleado(int id, Empleado empleado) async {
    final response = await _apiClient.put('$_endpoint$id/', empleado.toJson());
    if (response.statusCode == 200) {
      return Empleado.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al actualizar el empleado');
    }
  }

  Future<void> deleteEmpleado(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el empleado');
    }
  }
}