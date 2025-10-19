// lib/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard_screen.dart'; // Para volver al dashboard

// Importa todas tus pantallas de lista
import '../screens/presupuesto/presupuesto_list_screen.dart';
import '../screens/activo_fijo/activofijo_list_screen.dart';
import '../screens/proveedor/proveedor_list_screen.dart';
import '../screens/empleado/empleado_list_screen.dart';
import '../screens/departamento/departamento_list_screen.dart';
import '../screens/cargo/cargo_list_screen.dart';
import '../screens/categoria_activo/categoria_activo_list_screen.dart';
import '../screens/ubicacion/ubicacion_list_screen.dart';
import '../screens/estado_activo/estado_activo_list_screen.dart';
import '../screens/rol/rol_list_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Usuario del Sistema"),
            accountEmail: Text("Bienvenido"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.indigo),
            ),
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildDrawerItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  text: 'Dashboard',
                  onTap: () => _navigateTo(context, const DashboardScreen(), replace: true),
                ),
                const Divider(),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.monetization_on_outlined,
                  text: 'Presupuestos',
                  onTap: () => _navigateTo(context, const PresupuestoListScreen()),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.devices_other_outlined,
                  text: 'Activos Fijos',
                  onTap: () => _navigateTo(context, const ActivoFijoListScreen()),
                ),
                 _buildDrawerItem(
                  context: context,
                  icon: Icons.business_outlined,
                  text: 'Departamentos',
                  onTap: () => _navigateTo(context, const DepartamentoListScreen()),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.people_outline,
                  text: 'Proveedores',
                  onTap: () => _navigateTo(context, const ProveedorListScreen()),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.badge_outlined,
                  text: 'Empleados',
                  onTap: () => _navigateTo(context, const EmpleadoListScreen()),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.work_outline,
                  text: 'Cargos',
                  onTap: () => _navigateTo(context, const CargoListScreen()),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.category_outlined,
                  text: 'Categorías',
                  onTap: () => _navigateTo(context, const CategoriaActivoListScreen()),
                ),
                 _buildDrawerItem(
                  context: context,
                  icon: Icons.location_on_outlined,
                  text: 'Ubicaciones',
                  onTap: () => _navigateTo(context, const UbicacionListScreen()),
                ),
                 _buildDrawerItem(
                  context: context,
                  icon: Icons.toggle_on_outlined,
                  text: 'Estados',
                  onTap: () => _navigateTo(context, const EstadoActivoListScreen()),
                ),
                 _buildDrawerItem(
                  context: context,
                  icon: Icons.security_outlined,
                  text: 'Roles',
                  onTap: () => _navigateTo(context, const RolListScreen()),
                ),
              ],
            ),
          ),
          // Botón de Cerrar Sesión al final
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

  // --- MÉTODOS AUXILIARES DENTRO DE LA CLASE ---
  Widget _buildDrawerItem({required BuildContext context, required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget screen, {bool replace = false}) {
    Navigator.of(context).pop();
    if (replace) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    }
  }
}