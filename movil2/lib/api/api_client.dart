// lib/api/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // --- ¡IMPORTANTE! ---
  // Reemplaza esta IP con la IP de tu computadora en la red Wi-Fi
  final String _baseUrl = 'http://192.168.0.15:8000/api';
  
  final http.Client _client = http.Client();

  // Método privado para obtener los encabezados con el token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    // CORRECCIÓN: Ahora el token se añade a TODOS los tipos de petición
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }
    return headers;
  }

  // --- Métodos para las peticiones ---

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return _client.get(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
  }
  
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
     return _client.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    return _client.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    return _client.delete(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
  }
}