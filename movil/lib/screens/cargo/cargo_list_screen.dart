// lib/screens/cargo/cargo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cargo_provider.dart';
import 'cargo_edit_screen.dart';

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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (ctx, i) {
                final cargo = provider.items[i];
                return ListTile(
                  title: Text(cargo.nombre),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CargoEditScreen(cargo: cargo)),
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