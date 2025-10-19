// lib/screens/empleado/empleado_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/empleado_provider.dart';
import 'empleado_edit_screen.dart';
import '../../widgets/app_drawer.dart';

class EmpleadoListScreen extends StatefulWidget {
  const EmpleadoListScreen({super.key});

  @override
  State<EmpleadoListScreen> createState() => _EmpleadoListScreenState();
}

class _EmpleadoListScreenState extends State<EmpleadoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<EmpleadoProvider>(context, listen: false).fetchEmpleados());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmpleadoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Empleados')),
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchEmpleados(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: provider.empleados.length,
                itemBuilder: (ctx, i) {
                  final empleado = provider.empleados[i];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EmpleadoEditScreen(empleado: empleado)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.orange.shade100,
                              child: const Icon(Icons.badge_outlined, color: Colors.orange, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    empleado.nombreCompleto,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    empleado.cargoNombre,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  Text(
                                    empleado.departamentoNombre,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () { /* Lógica de eliminación */ },
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