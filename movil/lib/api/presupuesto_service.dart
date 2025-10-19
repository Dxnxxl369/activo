// lib/api/presupuesto_service.dart

import 'dart:convert';
import '../models/presupuesto.dart';
import 'api_client.dart';

class PresupuestoService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'presupuestos/';

  // LEER todos los presupuestos
  Future<List<Presupuesto>> getPresupuestos() async {
    final response = await _apiClient.get(_endpoint);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Presupuesto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los presupuestos');
    }
  }

  // ACTUALIZAR un presupuesto
  Future<Presupuesto> updatePresupuesto(int id, Presupuesto presupuesto) async {
    final response = await _apiClient.put('$_endpoint$id/', presupuesto.toJson());

    if (response.statusCode == 200) {
      return Presupuesto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar el presupuesto');
    }
  }

  // BORRAR un presupuesto
  Future<void> deletePresupuesto(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');

    if (response.statusCode != 204) { // 204 No Content es la respuesta exitosa para delete
      throw Exception('Error al eliminar el presupuesto');
    }
  }
}