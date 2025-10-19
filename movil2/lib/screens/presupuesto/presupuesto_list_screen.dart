// lib/screens/presupuesto/presupuesto_list_screen.dart
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/presupuesto_provider.dart';
import 'presupuesto_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

class PresupuestoListScreen extends StatefulWidget {
  const PresupuestoListScreen({super.key});

  @override
  State<PresupuestoListScreen> createState() => _PresupuestoListScreenState();
}

class _PresupuestoListScreenState extends State<PresupuestoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<PresupuestoProvider>(context, listen: false).fetchPresupuestos());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PresupuestoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos'),
      ),
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchPresupuestos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: provider.presupuestos.length,
                itemBuilder: (ctx, i) {
                  final presupuesto = provider.presupuestos[i];
                  return AnimatedListItem(
                    index: i,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PresupuestoEditScreen(presupuesto: presupuesto)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                child: Icon(Icons.monetization_on_outlined, color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(presupuesto.descripcion, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('Monto: \$${presupuesto.montoTotal}'),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () async {
                                  // Lógica de eliminación con confirmación
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}*/
// lib/screens/presupuesto/presupuesto_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/presupuesto_provider.dart';
import 'presupuesto_detail_screen.dart'; // <-- Cambiado a la pantalla de detalle
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

class PresupuestoListScreen extends StatefulWidget {
  const PresupuestoListScreen({super.key});
  @override
  State<PresupuestoListScreen> createState() => _PresupuestoListScreenState();
}

class _PresupuestoListScreenState extends State<PresupuestoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<PresupuestoProvider>(context, listen: false).fetchPresupuestos());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PresupuestoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Presupuestos')),
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchPresupuestos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: provider.presupuestos.length,
                itemBuilder: (ctx, i) {
                  final presupuesto = provider.presupuestos[i];
                  return AnimatedListItem(
                    index: i,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PresupuestoDetailScreen(presupuesto: presupuesto)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                child: Icon(Icons.monetization_on_outlined, color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(presupuesto.descripcion, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('Monto: \$${presupuesto.montoTotal}'),
                                  ],
                                ),
                              ),
                              const Icon(Icons.visibility_outlined, size: 20, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}