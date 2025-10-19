// lib/api/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String _baseUrl = 'http://192.168.0.15:8000/api';
  http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return _client.get(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
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