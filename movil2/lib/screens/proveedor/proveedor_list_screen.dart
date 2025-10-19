// lib/screens/proveedor/proveedor_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/proveedor_provider.dart';
import 'proveedor_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

class ProveedorListScreen extends StatefulWidget {
  const ProveedorListScreen({super.key});

  @override
  State<ProveedorListScreen> createState() => _ProveedorListScreenState();
}

class _ProveedorListScreenState extends State<ProveedorListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ProveedorProvider>(context, listen: false).fetchProveedores());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProveedorProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchProveedores(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: provider.proveedores.length,
                itemBuilder: (ctx, i) {
                  final proveedor = provider.proveedores[i];
                  return AnimatedListItem(
                    index: i,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProveedorEditScreen(proveedor: proveedor)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                child: Icon(Icons.store_mall_directory_outlined, color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(proveedor.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(proveedor.email ?? 'Sin email', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
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