// lib/screens/presupuesto/presupuesto_detail_screen.dart

import 'package:flutter/material.dart';
import '../../models/presupuesto.dart';
import 'presupuesto_edit_screen.dart';

class PresupuestoDetailScreen extends StatelessWidget {
  final Presupuesto presupuesto;
  const PresupuestoDetailScreen({super.key, required this.presupuesto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(presupuesto.descripcion),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PresupuestoEditScreen(presupuesto: presupuesto)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tarjeta de Resumen ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(context, icon: Icons.attach_money, title: 'Monto Total', value: '\$${presupuesto.montoTotal}'),
                    _buildDetailRow(context, icon: Icons.business_outlined, title: 'Empresa', value: presupuesto.empresaNombre),
                    _buildDetailRow(context, icon: Icons.date_range_outlined, title: 'Periodo', value: '${presupuesto.fechaInicio} al ${presupuesto.fechaFin}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Asignaciones', style: Theme.of(context).textTheme.headlineSmall),
            const Divider(thickness: 1),
            // --- Lista de Asignaciones ---
            if (presupuesto.detalles.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(child: Text('No hay asignaciones para este presupuesto.', style: TextStyle(color: Colors.grey))),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: presupuesto.detalles.length,
                itemBuilder: (ctx, i) {
                  final detalle = presupuesto.detalles[i];
                  return ListTile(
                    leading: const Icon(Icons.category_outlined),
                    title: Text(detalle.categoriaNombre),
                    trailing: Text('\$${detalle.montoAsignado}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 16),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}