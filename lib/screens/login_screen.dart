import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../providers/auth_provider.dart';

/// Pantalla de inicio de sesión.
///
/// Flujo: validar formulario -> AuthProvider.iniciarSesion -> POST /auth/login.
/// Si el servidor acepta las credenciales, AuthProvider cambia su estado y
/// AuthGate (en main.dart) reemplaza esta pantalla por la tienda; por eso aquí
/// no hay ninguna llamada a Navigator.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _ocultarPassword = true;

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    await context
        .read<AuthProvider>()
        .iniciarSesion(_usuarioCtrl.text.trim(), _passwordCtrl.text);
  }

  void _usarCredencialesDemo() {
    _usuarioCtrl.text = AppConstants.usuarioDemo;
    _passwordCtrl.text = AppConstants.passwordDemo;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tema = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.storefront,
                        size: 88, color: tema.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      AppConstants.nombreApp,
                      textAlign: TextAlign.center,
                      style: tema.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Inicia sesión para hacer tu pedido',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usuarioCtrl,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (valor) => (valor == null || valor.trim().isEmpty)
                          ? 'Escribe tu usuario'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _ocultarPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _enviar(),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _ocultarPassword
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          icon: Icon(_ocultarPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(
                              () => _ocultarPassword = !_ocultarPassword),
                        ),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Escribe tu contraseña';
                        }
                        if (valor.length < 4) {
                          return 'La contraseña es demasiado corta';
                        }
                        return null;
                      },
                    ),
                    if (auth.error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: tema.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          auth.error!,
                          style: TextStyle(
                              color: tema.colorScheme.onErrorContainer),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: auth.cargando ? null : _enviar,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: auth.cargando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Iniciar sesión'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _usarCredencialesDemo,
                      child: const Text('Usar credenciales de prueba'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
