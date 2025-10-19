// lib/screens/cargo/cargo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cargo_provider.dart';
import 'cargo_edit_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

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
                padding: const EdgeInsets.all(16.0),
                itemCount: provider.items.length,
                itemBuilder: (ctx, i) {
                  final cargo = provider.items[i];
                  return AnimatedListItem(
                    index: i,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CargoEditScreen(cargo: cargo)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                child: Icon(Icons.work_outline, color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(cargo.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () async {
                                  // Add deletion logic here
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