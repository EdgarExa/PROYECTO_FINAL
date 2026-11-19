import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TiendaAbarrotesApp());
}

/// Widget raíz. Registra los servicios y los estados (providers) que el resto
/// de la aplicación consume con `context.read` y `context.watch`.
class TiendaAbarrotesApp extends StatelessWidget {
  const TiendaAbarrotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Servicios (sin estado observable).
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<StorageService>(create: (_) => StorageService()),
        // Estados observables.
        ChangeNotifierProvider<AuthProvider>(
          create: (ctx) => AuthProvider(
            ctx.read<ApiService>(),
            ctx.read<StorageService>(),
          )..intentarSesionGuardada(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (ctx) => ProductProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (ctx) =>
              CartProvider(ctx.read<StorageService>())..cargar(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.nombreApp,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.claro,
        home: const AuthGate(),
      ),
    );
  }
}

/// Puerta de autenticación: muestra la pantalla que corresponde al estado de
/// la sesión (cargando, con sesión o sin sesión).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.select<AuthProvider, AuthStatus>((a) => a.estado);
    switch (estado) {
      case AuthStatus.desconocido:
        return const SplashScreen();
      case AuthStatus.autenticado:
        return const HomeShell();
      case AuthStatus.noAutenticado:
        return const LoginScreen();
    }
  }
}
