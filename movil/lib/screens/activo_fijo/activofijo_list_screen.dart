// lib/screens/activo_fijo/activofijo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activofijo_provider.dart';
import 'activofijo_edit_screen.dart';

class ActivoFijoListScreen extends StatefulWidget {
  const ActivoFijoListScreen({super.key});

  @override
  State<ActivoFijoListScreen> createState() => _ActivoFijoListScreenState();
}

class _ActivoFijoListScreenState extends State<ActivoFijoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ActivoFijoProvider>(context, listen: false).fetchActivosFijos());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivoFijoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Activos Fijos')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchActivosFijos(),
              child: ListView.builder(
                itemCount: provider.activos.length,
                itemBuilder: (ctx, i) {
                  final activo = provider.activos[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: ListTile(
                      title: Text(activo.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Valor: \$${activo.valorActual} - Ubicación: ${activo.ubicacionNombre}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ActivoFijoEditScreen(activoFijo: activo)),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              try {
                                await provider.deleteActivoFijo(activo.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Activo eliminado'), backgroundColor: Colors.green)
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error al eliminar'), backgroundColor: Colors.red)
                                );
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