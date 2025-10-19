// lib/screens/categoria_activo/categoria_activo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/categoria_activo_provider.dart';
import 'categoria_activo_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

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
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.items.length,
              itemBuilder: (ctx, i) {
                final item = provider.items[i];
                return AnimatedListItem(
                  index: i,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CategoriaActivoEditScreen(item: item)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              child: Icon(Icons.category_outlined, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                // Add deletion logic here
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