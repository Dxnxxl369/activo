// lib/api/ubicacion_service.dart

// --- CORRECCIÓN AQUÍ: Se cambió 'dart-convert' por 'dart:convert' ---
import 'dart:convert';
import '../models/ubicacion.dart';
import 'api_client.dart';

class UbicacionService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'ubicaciones/';

  Future<List<Ubicacion>> getItems() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      // Esta línea ahora funcionará porque 'jsonDecode' y 'utf8' son reconocidos
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Ubicacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar ubicaciones');
    }
  }

  Future<Ubicacion> updateItem(int id, Ubicacion item) async {
    final response = await _apiClient.put('$_endpoint$id/', item.toJson());
    if (response.statusCode == 200) {
      return Ubicacion.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al actualizar ubicación');
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await _apiClient.delete('$_endpoint$id/');
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar ubicación');
    }
  }
}