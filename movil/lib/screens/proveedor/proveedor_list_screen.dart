// lib/screens/proveedor/proveedor_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/proveedor_provider.dart';
import 'proveedor_edit_screen.dart';
import '../../widgets/app_drawer.dart';

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
                padding: const EdgeInsets.all(12.0),
                itemCount: provider.proveedores.length,
                itemBuilder: (ctx, i) {
                  final proveedor = provider.proveedores[i];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.black12, // <-- CORRECCIÓN APLICADA
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProveedorEditScreen(proveedor: proveedor)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.purple.shade100,
                              child: const Icon(Icons.store_mall_directory_outlined, color: Colors.purple, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proveedor.nombre,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    proveedor.email,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
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