import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

/// Perfil del usuario (datos obtenidos de `GET /auth/me`) y cierre de sesión.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que deseas salir de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (confirmar == true) await auth.cerrarSesion();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario;
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: usuario == null
          ? const Center(child: Text('Sin información de usuario'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: tema.colorScheme.primaryContainer,
                    foregroundImage: usuario.image.isNotEmpty
                        ? NetworkImage(usuario.image)
                        : null,
                    child: const Icon(Icons.person, size: 48),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  usuario.nombreCompleto,
                  textAlign: TextAlign.center,
                  style: tema.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.alternate_email),
                        title: const Text('Usuario'),
                        subtitle: Text(usuario.username),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Correo'),
                        subtitle: Text(usuario.email),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => _cerrarSesion(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar sesión'),
                ),
              ],
            ),
    );
  }
}
