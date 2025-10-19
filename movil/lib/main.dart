// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/presupuesto_provider.dart';
import 'providers/activofijo_provider.dart';
import 'providers/proveedor_provider.dart';
// --- Nuevas importaciones ---
import 'providers/empleado_provider.dart';
import 'providers/departamento_provider.dart';
import 'providers/cargo_provider.dart';
import 'providers/categoria_activo_provider.dart';
import 'providers/ubicacion_provider.dart';
import 'providers/estado_activo_provider.dart';
import 'providers/rol_provider.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PresupuestoProvider()),
        ChangeNotifierProvider(create: (_) => ActivoFijoProvider()),
        ChangeNotifierProvider(create: (_) => ProveedorProvider()),
        // --- Nuevos Providers ---
        ChangeNotifierProvider(create: (_) => EmpleadoProvider()),
        ChangeNotifierProvider(create: (_) => DepartamentoProvider()),
        ChangeNotifierProvider(create: (_) => CargoProvider()),
        ChangeNotifierProvider(create: (_) => CategoriaActivoProvider()),
        ChangeNotifierProvider(create: (_) => UbicacionProvider()),
        ChangeNotifierProvider(create: (_) => EstadoActivoProvider()),
        ChangeNotifierProvider(create: (_) => RolProvider()),      
      ],
      child: MaterialApp(
        title: 'Gestión de Activos',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
          },
        ),
      ),
    );
  }
}