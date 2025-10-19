// lib/screens/departamento/departamento_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/departamento_provider.dart';
import 'departamento_edit_screen.dart';
import '../../widgets/app_drawer.dart';

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
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchDepartamentos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: provider.items.length,
                itemBuilder: (ctx, i) {
                  final depto = provider.items[i];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DepartamentoEditScreen(departamento: depto)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                           children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.teal.shade100,
                              child: const Icon(Icons.business_outlined, color: Colors.teal, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                depto.nombre,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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