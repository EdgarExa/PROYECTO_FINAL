import 'app_user.dart';

/// Resultado de un inicio de sesión exitoso: el usuario y su token de acceso.
class AuthSession {
  const AuthSession({required this.user, required this.token});

  final AppUser user;
  final String token;
}
