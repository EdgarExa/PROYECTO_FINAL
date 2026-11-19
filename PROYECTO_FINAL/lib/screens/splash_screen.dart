import 'package:flutter/material.dart';

import '../core/constants.dart';

/// Pantalla de bienvenida mientras se verifica si existe una sesión guardada.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: esquema.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront, size: 96, color: esquema.onPrimary),
            const SizedBox(height: 16),
            Text(
              AppConstants.nombreApp,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: esquema.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(color: esquema.onPrimary),
          ],
        ),
      ),
    );
  }
}
