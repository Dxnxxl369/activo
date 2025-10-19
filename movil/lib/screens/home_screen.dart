import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'presupuesto/presupuesto_list_screen.dart';

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
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildMenuOption(
            context,
            icon: Icons.monetization_on,
            title: 'Gestión de Presupuestos',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const PresupuestoListScreen(),
                ),
              );
            },
          ),
          // Aquí puedes añadir más opciones para otros módulos
          // _buildMenuOption(context, icon: Icons.devices, title: 'Activos Fijos', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}