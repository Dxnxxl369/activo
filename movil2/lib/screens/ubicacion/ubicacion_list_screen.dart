// lib/screens/ubicacion/ubicacion_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ubicacion_provider.dart';
import 'ubicacion_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

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
                        MaterialPageRoute(builder: (_) => UbicacionEditScreen(item: item)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              child: Icon(Icons.location_on_outlined, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  if(item.direccion != null && item.direccion!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(item.direccion!, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                  ]
                                ],
                              ),
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