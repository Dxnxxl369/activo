// lib/screens/proveedor/proveedor_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/proveedor_provider.dart';
import 'proveedor_edit_screen.dart';

class ProveedorListScreen extends StatefulWidget {
  const ProveedorListScreen({super.key});

  @override
  State<ProveedorListScreen> createState() => _ProveedorListScreenState();
}

class _ProveedorListScreenState extends State<ProveedorListScreen> {
  @override
  void initState() {
    super.initState();
    // Usamos Future.microtask para asegurar que el context esté disponible
    Future.microtask(() =>
        Provider.of<ProveedorProvider>(context, listen: false).fetchProveedores());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProveedorProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchProveedores(),
              child: ListView.builder(
                itemCount: provider.proveedores.length,
                itemBuilder: (ctx, i) {
                  final proveedor = provider.proveedores[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(proveedor.nombre.substring(0, 1)),
                      ),
                      title: Text(proveedor.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(proveedor.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ProveedorEditScreen(proveedor: proveedor)),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirmar Eliminación'),
                                  content: Text('¿Seguro que quieres eliminar a ${proveedor.nombre}?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                try {
                                  await provider.deleteProveedor(proveedor.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Proveedor eliminado'), backgroundColor: Colors.green)
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Error al eliminar'), backgroundColor: Colors.red)
                                  );
                                }
                              }
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