// lib/screens/estado_activo/estado_activo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/estado_activo_provider.dart';
import 'estado_activo_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

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
                        MaterialPageRoute(builder: (_) => EstadoActivoEditScreen(item: item)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              child: Icon(Icons.toggle_on_outlined, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                // Lógica de borrado con confirmación
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