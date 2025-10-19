// lib/screens/rol/rol_detail_screen.dart

import 'package:flutter/material.dart';
import '../../models/rol.dart';

class RolDetailScreen extends StatelessWidget {
  final Rol rol;
  const RolDetailScreen({super.key, required this.rol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rol.nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: Theme.of(context).primaryColor, size: 30),
                const SizedBox(width: 12),
                Text(
                  'Permisos Asignados',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1),
            if (rol.permisos.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Este rol no tiene permisos asignados.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: rol.permisos.map((permiso) {
                  return Chip(
                    avatar: Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.onSecondaryContainer, size: 18),
                    label: Text(permiso.nombre),
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}