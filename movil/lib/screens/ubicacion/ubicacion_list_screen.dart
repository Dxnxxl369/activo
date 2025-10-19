// lib/screens/ubicacion/ubicacion_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ubicacion_provider.dart';
import 'ubicacion_edit_screen.dart';

class UbicacionListScreen extends StatefulWidget {
  const UbicacionListScreen({super.key});

  @override
  State<UbicacionListScreen> createState() => _UbicacionListScreenState();
}

class _UbicacionListScreenState extends State<UbicacionListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<UbicacionProvider>(context, listen: false).fetchItems());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UbicacionProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicaciones')),
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
                          MaterialPageRoute(builder: (_) => UbicacionEditScreen(item: item)),
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