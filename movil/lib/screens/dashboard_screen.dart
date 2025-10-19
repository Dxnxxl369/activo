// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/kpi_card.dart';
import '../widgets/animated_slide_fade.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar los datos del dashboard al iniciar la pantalla
    Future.microtask(() => Provider.of<DashboardProvider>(context, listen: false).fetchDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final data = provider.dashboardData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const AppDrawer(), // <-- Aquí añadimos el menú desplegable
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDashboardData(),
        child: provider.isLoading && data == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Resumen General",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    if (data != null) ...[
                      AnimatedSlideFade(
                        delay: 100,
                        child: KpiCard(
                          title: 'Valor Total de Activos',
                          value: '\$${data.valorTotalActivos}',
                          icon: Icons.account_balance_wallet_outlined,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSlideFade(
                        delay: 200,
                        child: KpiCard(
                          title: 'Presupuesto Total Activo',
                          value: '\$${data.presupuestoTotal}',
                          icon: Icons.monetization_on_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSlideFade(
                        delay: 300,
                        child: KpiCard(
                          title: 'Total de Empleados',
                          value: data.totalEmpleados.toString(),
                          icon: Icons.people_alt_outlined,
                          color: Colors.purple,
                        ),
                      ),
                       const SizedBox(height: 16),
                      AnimatedSlideFade(
                        delay: 400,
                        child: KpiCard(
                          title: 'Proveedores Activos',
                          value: data.proveedoresActivos.toString(),
                          icon: Icons.store_mall_directory_outlined,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    const Text(
                      "Actividad Reciente",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                           BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ]
                      ),
                      child: const Center(
                        child: Text(
                          'No hay actividad reciente para mostrar.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}