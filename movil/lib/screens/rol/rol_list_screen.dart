// lib/screens/rol/rol_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rol_provider.dart';
import 'rol_detail_screen.dart';

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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.roles.length,
              itemBuilder: (ctx, i) {
                final rol = provider.roles[i];
                return ListTile(
                  title: Text(rol.nombre),
                  subtitle: Text("${rol.permisos.length} permisos asignados"),
                  trailing: const Icon(Icons.visibility_outlined, color: Colors.grey),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RolDetailScreen(rol: rol)),
                  ),
                );
              },
            ),
    );
  }
}