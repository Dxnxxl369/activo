// lib/providers/dashboard_provider.dart

import 'package:flutter/foundation.dart';
import '../models/dashboard_data.dart';
import '../api/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _service = DashboardService();
  DashboardData? _dashboardData;
  bool _isLoading = false;

  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _dashboardData = await _service.getDashboardData();
    } catch (e) {
      debugPrint("Error al cargar datos del dashboard: $e");
      // En caso de error, podemos inicializar con datos vacíos para evitar que la UI se rompa
      _dashboardData = DashboardData(
        valorTotalActivos: 'Error',
        presupuestoTotal: 'Error',
        totalEmpleados: 0,
        proveedoresActivos: 0,
      );
    }
    _isLoading = false;
    notifyListeners();
  }
}