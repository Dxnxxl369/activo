// lib/screens/activo_fijo/activofijo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activofijo_provider.dart';
import 'activofijo_edit_screen.dart';
import '../../widgets/app_drawer.dart';

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
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchActivosFijos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: provider.activos.length,
                itemBuilder: (ctx, i) {
                  final activo = provider.activos[i];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ActivoFijoEditScreen(activoFijo: activo)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(Icons.devices_other_outlined, color: Colors.green, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activo.nombre,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Valor: \$${activo.valorActual}",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  Text(
                                    "Ubicación: ${activo.ubicacionNombre}",
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
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