// lib/screens/departamento/departamento_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/departamento_provider.dart';
import 'departamento_edit_screen.dart';

class DepartamentoListScreen extends StatefulWidget {
  const DepartamentoListScreen({super.key});

  @override
  State<DepartamentoListScreen> createState() => _DepartamentoListScreenState();
}

class _DepartamentoListScreenState extends State<DepartamentoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<DepartamentoProvider>(context, listen: false).fetchDepartamentos());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DepartamentoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Departamentos')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (ctx, i) {
                final depto = provider.items[i];
                return ListTile(
                  title: Text(depto.nombre),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => DepartamentoEditScreen(departamento: depto)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () async {
                          // Lógica de eliminación
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}