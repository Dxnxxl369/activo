// lib/screens/categoria_activo/categoria_activo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/categoria_activo_provider.dart';
import 'categoria_activo_edit_screen.dart';
import '../../widgets/app_drawer.dart';

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
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
            onRefresh: () => provider.fetchItems(),
            child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: provider.items.length,
                itemBuilder: (ctx, i) {
                  final item = provider.items[i];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CategoriaActivoEditScreen(item: item)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                           children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.cyan.shade100,
                              child: const Icon(Icons.category_outlined, color: Colors.cyan, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item.nombre,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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