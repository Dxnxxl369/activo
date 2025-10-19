// lib/screens/rol/rol_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rol_provider.dart';
import 'rol_detail_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animated_list_item.dart';

class RolListScreen extends StatefulWidget {
  const RolListScreen({super.key});

  @override
  State<RolListScreen> createState() => _RolListScreenState();
}

class _RolListScreenState extends State<RolListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<RolProvider>(context, listen: false).fetchRoles());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RolProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Roles y Permisos')),
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
            onRefresh: () => provider.fetchRoles(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.roles.length,
              itemBuilder: (ctx, i) {
                final rol = provider.roles[i];
                return AnimatedListItem(
                  index: i,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RolDetailScreen(rol: rol)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              child: Icon(Icons.security_outlined, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rol.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${rol.permisos.length} permisos asignados",
                                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.visibility_outlined, size: 20, color: Colors.grey),
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