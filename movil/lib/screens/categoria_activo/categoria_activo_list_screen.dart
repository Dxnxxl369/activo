// lib/screens/categoria_activo/categoria_activo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/categoria_activo_provider.dart';
import 'categoria_activo_edit_screen.dart';

class CategoriaActivoListScreen extends StatefulWidget {
  const CategoriaActivoListScreen({super.key});

  @override
  State<CategoriaActivoListScreen> createState() => _CategoriaActivoListScreenState();
}

class _CategoriaActivoListScreenState extends State<CategoriaActivoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<CategoriaActivoProvider>(context, listen: false).fetchItems());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoriaActivoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías de Activos')),
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
                          MaterialPageRoute(builder: (_) => CategoriaActivoEditScreen(item: item)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}