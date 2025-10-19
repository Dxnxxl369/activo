// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// Importaciones de las pantallas de lista
import 'presupuesto/presupuesto_list_screen.dart';
import 'activo_fijo/activofijo_list_screen.dart';
import 'proveedor/proveedor_list_screen.dart';
import 'empleado/empleado_list_screen.dart';
import 'departamento/departamento_list_screen.dart';
import 'cargo/cargo_list_screen.dart';
import 'categoria_activo/categoria_activo_list_screen.dart';
import 'ubicacion/ubicacion_list_screen.dart';
import 'estado_activo/estado_activo_list_screen.dart';
import 'rol/rol_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2, // Mostramos 2 tarjetas por fila
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            icon: Icons.monetization_on_outlined,
            title: 'Presupuestos',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PresupuestoListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.devices_other_outlined,
            title: 'Activos Fijos',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ActivoFijoListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.people_outline,
            title: 'Proveedores',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProveedorListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.badge_outlined,
            title: 'Empleados',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmpleadoListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.business_outlined,
            title: 'Departamentos',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DepartamentoListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.work_outline,
            title: 'Cargos',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CargoListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.category_outlined,
            title: 'Categorías',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CategoriaActivoListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.location_on_outlined,
            title: 'Ubicaciones',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UbicacionListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.toggle_on_outlined,
            title: 'Estados',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EstadoActivoListScreen())),
          ),
          _buildMenuCard(
            context,
            icon: Icons.security_outlined,
            title: 'Roles',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RolListScreen())),
          ),
        ],
      ),
    );
  }

  // Nuevo widget para las tarjetas del menú
  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 4,
        shadowColor: Colors.indigo.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.indigo),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}