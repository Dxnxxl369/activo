// lib/api/dashboard_service.dart

import 'dart:convert';
import '../models/dashboard_data.dart';
import 'api_client.dart';

class DashboardService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = 'dashboard/';

  Future<DashboardData> getDashboardData() async {
    final response = await _apiClient.get(_endpoint);
    if (response.statusCode == 200) {
      return DashboardData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al cargar los datos del dashboard');
    }
  }
}