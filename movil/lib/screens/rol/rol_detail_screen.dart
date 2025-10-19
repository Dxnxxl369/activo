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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permisos Asignados:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: rol.permisos.isEmpty
                  ? const Text('Este rol no tiene permisos asignados.')
                  : Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: rol.permisos.map((permiso) {
                        return Chip(
                          label: Text(permiso.nombre),
                          backgroundColor: Colors.blue.shade100,
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}