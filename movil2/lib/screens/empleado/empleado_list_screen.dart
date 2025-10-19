// lib/screens/empleado/empleado_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/empleado_provider.dart';
import 'empleado_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

class EmpleadoListScreen extends StatefulWidget {
  const EmpleadoListScreen({super.key});

  @override
  State<EmpleadoListScreen> createState() => _EmpleadoListScreenState();
}

class _EmpleadoListScreenState extends State<EmpleadoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<EmpleadoProvider>(context, listen: false).fetchEmpleados());
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
                padding: const EdgeInsets.all(16.0),
                itemCount: provider.empleados.length,
                itemBuilder: (ctx, i) {
                  final empleado = provider.empleados[i];
                  return AnimatedListItem(
                    index: i,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EmpleadoEditScreen(empleado: empleado)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                child: Icon(Icons.badge_outlined, color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(empleado.nombreCompleto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(empleado.cargoNombre, style: TextStyle(color: Colors.grey[400])),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () async {
                                  // Add deletion logic with confirmation dialog here
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
}