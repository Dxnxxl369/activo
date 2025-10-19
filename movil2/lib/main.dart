// main.dart
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa tus providers
import 'providers/departamento_provider.dart';
import 'providers/cargo_provider.dart';
import 'providers/categoria_activo_provider.dart';
import 'providers/ubicacion_provider.dart';
import 'providers/estado_activo_provider.dart';
import 'providers/activofijo_provider.dart';

import 'providers/proveedor_provider.dart';
import 'providers/empleado_provider.dart';
import 'providers/rol_provider.dart'; // Asegúrate de tener este provider

// Importa tus pantallas
import 'screens/dashboard_screen.dart'; // Tu nueva pantalla de Dashboard
import 'screens/departamento/departamento_list_screen.dart';
import 'screens/cargo/cargo_list_screen.dart';
import 'screens/categoria_activo/categoria_activo_list_screen.dart';
import 'screens/ubicacion/ubicacion_list_screen.dart';
import 'screens/estado_activo/estado_activo_list_screen.dart';
import 'screens/proveedor/proveedor_list_screen.dart';
import 'screens/empleado/empleado_list_screen.dart';
import 'screens/rol/rol_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Aquí registras todos tus providers
        ChangeNotifierProvider(create: (_) => DepartamentoProvider()),
        ChangeNotifierProvider(create: (_) => CargoProvider()),
        ChangeNotifierProvider(create: (_) => CategoriaActivoProvider()),
        ChangeNotifierProvider(create: (_) => UbicacionProvider()),
        ChangeNotifierProvider(create: (_) => EstadoActivoProvider()),
        ChangeNotifierProvider(create: (_) => ProveedorProvider()),
        ChangeNotifierProvider(create: (_) => EmpleadoProvider()),
        ChangeNotifierProvider(create: (_) => RolProvider()), // Añade el provider de Roles
        // ... otros providers que puedas tener
      ],
      child: MaterialApp(
        title: 'Gestión de Activos',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.amber,
          ).copyWith(secondary: Colors.amber),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        home: const DashboardScreen(), // La pantalla de inicio ahora es el Dashboard
        routes: {
          // Define las rutas para cada pantalla de lista
          '/dashboard': (ctx) => const DashboardScreen(),
          '/departamentos': (ctx) => const DepartamentoListScreen(),
          '/cargos': (ctx) => const CargoListScreen(),
          '/categorias-activos': (ctx) => const CategoriaActivoListScreen(),
          '/ubicaciones': (ctx) => const UbicacionListScreen(),
          '/estados-activos': (ctx) => const EstadoActivoListScreen(),
          '/proveedores': (ctx) => const ProveedorListScreen(),
          '/empleados': (ctx) => const EmpleadoListScreen(),
          '/roles': (ctx) => const RolListScreen(), // Ruta para Roles y Permisos
        },
      ),
    );
  }
}*/
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';

// Importa TODOS tus providers
import 'providers/auth_provider.dart';
import 'providers/departamento_provider.dart';
import 'providers/cargo_provider.dart';
import 'providers/categoria_activo_provider.dart';
import 'providers/ubicacion_provider.dart';
import 'providers/estado_activo_provider.dart';
import 'providers/proveedor_provider.dart';
import 'providers/empleado_provider.dart';
import 'providers/rol_provider.dart';
import 'providers/presupuesto_provider.dart';
import 'providers/activofijo_provider.dart'; // Módulo que faltaba
import 'providers/empresa_provider.dart'; // Módulo que faltaba
import 'providers/dashboard_provider.dart';
import 'providers/theme_provider.dart';

// Importa las pantallas de inicio
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Lista completa de providers
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DepartamentoProvider()),
        ChangeNotifierProvider(create: (_) => CargoProvider()),
        ChangeNotifierProvider(create: (_) => CategoriaActivoProvider()),
        ChangeNotifierProvider(create: (_) => UbicacionProvider()),
        ChangeNotifierProvider(create: (_) => EstadoActivoProvider()),
        ChangeNotifierProvider(create: (_) => ProveedorProvider()),
        ChangeNotifierProvider(create: (_) => EmpleadoProvider()),
        ChangeNotifierProvider(create: (_) => RolProvider()),
        ChangeNotifierProvider(create: (_) => PresupuestoProvider()),
        ChangeNotifierProvider(create: (_) => ActivoFijoProvider()),
        ChangeNotifierProvider(create: (_) => EmpresaProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Gestión de Activos',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return auth.isAuthenticated ? const DashboardScreen() : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}