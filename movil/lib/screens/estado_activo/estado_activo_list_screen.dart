// lib/screens/estado_activo/estado_activo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/estado_activo_provider.dart';
import 'estado_activo_edit_screen.dart';

class EstadoActivoListScreen extends StatefulWidget {
  const EstadoActivoListScreen({super.key});

  @override
  State<EstadoActivoListScreen> createState() => _EstadoActivoListScreenState();
}

class _EstadoActivoListScreenState extends State<EstadoActivoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<EstadoActivoProvider>(context, listen: false).fetchItems());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EstadoActivoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Estados de Activos')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (ctx, i) {
                final item = provider.items[i];
                return ListTile(
                  title: Text(item.nombre),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EstadoActivoEditScreen(item: item)),
                        ),
                      ),
                       IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          // Lógica de eliminación
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}