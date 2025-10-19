// lib/screens/departamento/departamento_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/departamento_provider.dart';
import 'departamento_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

class DepartamentoListScreen extends StatefulWidget {
  const DepartamentoListScreen({super.key});

  @override
  State<DepartamentoListScreen> createState() => _DepartamentoListScreenState();
}

class _DepartamentoListScreenState extends State<DepartamentoListScreen> {
  @override
  void initState() {
    super.initState();
    // CORRECCIÓN: Cargamos los datos de forma segura
    Future.microtask(() => Provider.of<DepartamentoProvider>(context, listen: false).fetchDepartamentos());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DepartamentoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Departamentos'),
      ),
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchDepartamentos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: provider.items.length,
                itemBuilder: (ctx, i) {
                  final depto = provider.items[i];
                  return AnimatedListItem(
                    index: i,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => DepartamentoEditScreen(departamento: depto)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                child: Icon(Icons.business_outlined, color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(depto.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                              // --- NUEVO: FUNCIONALIDAD DE BORRADO ---
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Confirmar Eliminación'),
                                      content: Text('¿Seguro que quieres eliminar el departamento "${depto.nombre}"?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(true),
                                          child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    try {
                                      await provider.deleteDepartamento(depto.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Departamento eliminado'), backgroundColor: Colors.green)
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
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}