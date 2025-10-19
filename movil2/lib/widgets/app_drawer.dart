
// lib/widgets/app_drawer.dart

/*import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.business_center, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Gestión de Activos',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            routeName: '/dashboard',
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.apartment_outlined,
            title: 'Departamentos',
            routeName: '/departamentos',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.work_outline,
            title: 'Cargos',
            routeName: '/cargos',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.category_outlined,
            title: 'Categorías de Activos',
            routeName: '/categorias-activos',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.location_on_outlined,
            title: 'Ubicaciones',
            routeName: '/ubicaciones',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.toggle_on_outlined,
            title: 'Estados de Activos',
            routeName: '/estados-activos',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.store_mall_directory_outlined,
            title: 'Proveedores',
            routeName: '/proveedores',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.badge_outlined,
            title: 'Empleados',
            routeName: '/empleados',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.security_outlined,
            title: 'Roles y Permisos',
            routeName: '/roles',
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Configuración',
            onTap: () {
              // Navegar a la pantalla de configuración o mostrar un diálogo
              Navigator.pop(context); // Cierra el drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegar a Configuración')),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout_outlined,
            title: 'Cerrar Sesión',
            onTap: () {
              // Lógica para cerrar sesión
              Navigator.pop(context); // Cierra el drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cerrando Sesión...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {
    required IconData icon,
    required String title,
    String? routeName,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap ?? () {
        if (routeName != null) {
          Navigator.of(context).pushReplacementNamed(routeName);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}*/
// lib/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:movil2/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

// Importa TODAS tus pantallas de lista
import '../screens/dashboard_screen.dart';
import '../screens/presupuesto/presupuesto_list_screen.dart';
import '../screens/activo_fijo/activofijo_list_screen.dart';
import '../screens/empresa/empresa_list_screen.dart'; // <-- Nuevo
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Usuario del Sistema", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("Bienvenido"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person_outline, size: 50, color: AppTheme.primaryColor),
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
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
                // --- MÓDULOS AÑADIDOS ---
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
                  icon: Icons.business_center_outlined,
                  text: 'Empresas',
                  onTap: () => _navigateTo(context, const EmpresaListScreen()),
                ),
                // --- Resto de Módulos ---
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
                  icon: Icons.business_outlined,
                  text: 'Departamentos',
                  onTap: () => _navigateTo(context, const DepartamentoListScreen()),
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
                  text: 'Categorías de Activos',
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
                  text: 'Estados de Activos',
                  onTap: () => _navigateTo(context, const EstadoActivoListScreen()),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.security_outlined,
                  text: 'Roles y Permisos',
                  onTap: () => _navigateTo(context, const RolListScreen()),
                ),                
                // ... y así con todos los demás...
              ],
            ),
          ),
          const Divider(),
          // --- INTERRUPTOR DE TEMA ---
          SwitchListTile.adaptive(
            title: const Text('Modo Oscuro'),
            secondary: Icon(
              themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            ),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              // 1. Llama a la lógica de logout para limpiar el estado
              Provider.of<AuthProvider>(context, listen: false).logout();

              // 2. FUERZA la navegación a la pantalla de login y BORRA todas las rutas anteriores
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false, // Este predicado elimina todo el historial
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required BuildContext context, required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget screen, {bool replace = false}) {
    Navigator.of(context).pop();
    final currentRoute = ModalRoute.of(context);
    // Evita navegar a la misma página si ya estamos en ella
    if (currentRoute?.settings.name != screen.runtimeType.toString()) {
      if (replace) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen, settings: RouteSettings(name: screen.runtimeType.toString())));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen, settings: RouteSettings(name: screen.runtimeType.toString())));
      }
    }
  }
}