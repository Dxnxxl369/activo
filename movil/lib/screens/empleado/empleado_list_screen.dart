// lib/screens/empleado/empleado_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/empleado_provider.dart';
import 'empleado_edit_screen.dart';

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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchEmpleados(),
              child: ListView.builder(
                itemCount: provider.empleados.length,
                itemBuilder: (ctx, i) {
                  final empleado = provider.empleados[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: ListTile(
                      title: Text(empleado.nombreCompleto, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${empleado.cargoNombre} - ${empleado.departamentoNombre}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => EmpleadoEditScreen(empleado: empleado)),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              // Lógica de confirmación y eliminación
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}