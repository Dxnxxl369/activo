// lib/screens/activo_fijo/activofijo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activofijo_provider.dart';
import 'activofijo_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

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
                padding: const EdgeInsets.all(16.0),
                itemCount: provider.activos.length,
                itemBuilder: (ctx, i) {
                  final activo = provider.activos[i];
                  return AnimatedListItem(
                    index: i,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ActivoFijoEditScreen(activoFijo: activo)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                child: Icon(Icons.devices_other_outlined, color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(activo.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text("Valor: \$${activo.valorActual}"),
                                    Text("Estado: ${activo.estadoNombre}", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
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