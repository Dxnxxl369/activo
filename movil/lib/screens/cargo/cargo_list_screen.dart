// lib/screens/cargo/cargo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cargo_provider.dart';
import 'cargo_edit_screen.dart';
import '../../widgets/app_drawer.dart';

class CargoListScreen extends StatefulWidget {
  const CargoListScreen({super.key});

  @override
  State<CargoListScreen> createState() => _CargoListScreenState();
}

class _CargoListScreenState extends State<CargoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<CargoProvider>(context, listen: false).fetchCargos());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CargoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cargos')),
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchCargos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: provider.items.length,
                itemBuilder: (ctx, i) {
                  final cargo = provider.items[i];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CargoEditScreen(cargo: cargo)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                           children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.pink.shade100,
                              child: const Icon(Icons.work_outline, color: Colors.pink, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                cargo.nombre,
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