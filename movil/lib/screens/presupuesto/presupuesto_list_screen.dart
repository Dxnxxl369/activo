// lib/screens/presupuesto/presupuesto_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/presupuesto_provider.dart';
import 'presupuesto_edit_screen.dart';
import '../../widgets/app_drawer.dart'; // Importamos el nuevo menú

class PresupuestoListScreen extends StatefulWidget {
  const PresupuestoListScreen({super.key});

  @override
  State<PresupuestoListScreen> createState() => _PresupuestoListScreenState();
}

class _PresupuestoListScreenState extends State<PresupuestoListScreen> {
  @override
  void initState() {
    super.initState();
    // SOLUCIÓN AL BUG: Usamos Future.microtask para cargar los datos de forma segura.
    Future.microtask(() =>
        Provider.of<PresupuestoProvider>(context, listen: false).fetchPresupuestos());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PresupuestoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos'),
      ),
      drawer: const AppDrawer(), // <-- AÑADIMOS EL MENÚ DESPLEGABLE AQUÍ
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchPresupuestos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: provider.presupuestos.length,
                itemBuilder: (ctx, i) {
                  final presupuesto = provider.presupuestos[i];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => PresupuestoEditScreen(presupuesto: presupuesto)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(Icons.monetization_on_outlined, color: Colors.blue, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    presupuesto.descripcion,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Monto: \$${presupuesto.montoTotal}',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  Text(
                                    'Empresa: ${presupuesto.empresaNombre}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                // Lógica de eliminación
                              },
                            ),
                          ],
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