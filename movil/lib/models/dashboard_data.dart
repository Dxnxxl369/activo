// lib/models/dashboard_data.dart
class DashboardData {
  final String valorTotalActivos;
  final String presupuestoTotal;
  final int totalEmpleados;
  final int proveedoresActivos;

  DashboardData({
    required this.valorTotalActivos,
    required this.presupuestoTotal,
    required this.totalEmpleados,
    required this.proveedoresActivos,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      valorTotalActivos: json['valor_total_activos'] ?? '0.00',
      presupuestoTotal: json['presupuesto_total'] ?? '0.00',
      totalEmpleados: json['total_empleados'] ?? 0,
      proveedoresActivos: json['proveedores_activos'] ?? 0,
    );
  }
}