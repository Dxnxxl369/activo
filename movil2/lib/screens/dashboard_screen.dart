// lib/screens/dashboard_screen.dart
/*
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Importa la librería de gráficos
import '../widgets/app_drawer.dart'; // Asegúrate de que este path sea correcto

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Activos'),
      ),
      drawer: const AppDrawer(), // El cajón de navegación para todos los módulos
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, [Nombre de Usuario]', // Reemplazar con el nombre de usuario real
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildMetricCards(context),
            const SizedBox(height: 30),
            Text(
              'Estadísticas Clave',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPieChartCard(context),
            const SizedBox(height: 20),
            _buildBarChartCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCards(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard(
          context,
          'Activos Totales',
          '250',
          Icons.apartment,
          Colors.blueAccent,
        ),
        _buildMetricCard(
          context,
          'Activos en Mantenimiento',
          '15',
          Icons.build_circle,
          Colors.orangeAccent,
        ),
        _buildMetricCard(
          context,
          'Presupuesto del Mes',
          '\$15,000',
          Icons.account_balance_wallet,
          Colors.greenAccent,
        ),
        _buildMetricCard(
          context,
          'Próximas Disposiciones',
          '3',
          Icons.delete_sweep,
          Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activos por Categoría',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _getPieChartSections(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // Puedes añadir lógica interactiva aquí
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    return List.generate(4, (i) {
      const isTouched = false; // Puedes cambiar esto con el estado del touch
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const widgetSize = 20.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.lightBlue,
            value: 40,
            title: 'Oficina (40%)',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: _Badge(Icons.desktop_windows, isTouched: isTouched),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: 30,
            title: 'Vehículos (30%)',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: _Badge(Icons.directions_car, isTouched: isTouched),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.orange,
            value: 20,
            title: 'Maquinaria (20%)',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: _Badge(Icons.construction, isTouched: isTouched),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.red,
            value: 10,
            title: 'IT (10%)',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: _Badge(Icons.devices, isTouched: isTouched),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }

  Widget _buildLegend() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LegendRow(color: Colors.lightBlue, title: 'Activos de Oficina'),
        _LegendRow(color: Colors.green, title: 'Vehículos'),
        _LegendRow(color: Colors.orange, title: 'Maquinaria'),
        _LegendRow(color: Colors.red, title: 'Activos de TI'),
      ],
    );
  }

  Widget _buildBarChartCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movimientos de Activos (Últimos 6 meses)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: _getBarGroups(),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final titles = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(titles[value.toInt()]),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                        interval: 10,
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(6, (i) {
      switch (i) {
        case 0: return _makeBarChartGroupData(0, 35);
        case 1: return _makeBarChartGroupData(1, 48);
        case 2: return _makeBarChartGroupData(2, 25);
        case 3: return _makeBarChartGroupData(3, 55);
        case 4: return _makeBarChartGroupData(4, 30);
        case 5: return _makeBarChartGroupData(5, 42);
        default: return throw Error();
      }
    });
  }

  BarChartGroupData _makeBarChartGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.deepPurpleAccent,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      showingTooltipIndicators: [],
    );
  }
}

// Widget auxiliar para las etiquetas del PieChart
class _Badge extends StatelessWidget {
  const _Badge(
    this.icon, {
    required this.isTouched,
  });
  final IconData icon;
  final bool isTouched;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: isTouched ? 40 : 28,
      height: isTouched ? 40 : 28,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(isTouched ? 8.0 : 6.0),
      child: Center(
        child: Icon(
          icon,
          size: isTouched ? 22 : 16,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

// Widget auxiliar para la leyenda
class _LegendRow extends StatelessWidget {
  final Color color;
  final String title;

  const _LegendRow({required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}*/
// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/kpi_card.dart';
import '../widgets/animated_list_item.dart';

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
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDashboardData(),
        child: (provider.isLoading && data == null)
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Resumen General",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        AnimatedListItem(
                          index: 0,
                          child: KpiCard(
                            title: 'Valor Total de Activos',
                            value: '\$${data?.valorTotalActivos ?? '...'}',
                            icon: Icons.account_balance_wallet_outlined,
                            color: Colors.green,
                          ),
                        ),
                        AnimatedListItem(
                          index: 1,
                          child: KpiCard(
                            title: 'Presupuesto Total',
                            value: '\$${data?.presupuestoTotal ?? '...'}',
                            icon: Icons.monetization_on_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        AnimatedListItem(
                          index: 2,
                          child: KpiCard(
                            title: 'Total de Empleados',
                            value: data?.totalEmpleados.toString() ?? '...',
                            icon: Icons.people_alt_outlined,
                            color: Colors.purple,
                          ),
                        ),
                        AnimatedListItem(
                          index: 3,
                          child: KpiCard(
                            title: 'Proveedores Activos',
                            value: data?.proveedoresActivos.toString() ?? '...',
                            icon: Icons.store_mall_directory_outlined,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Actividad Reciente",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            'No hay actividad reciente para mostrar.',
                            style: TextStyle(color: Colors.grey),
                          ),
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