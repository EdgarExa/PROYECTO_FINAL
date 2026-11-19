import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Estado de la sesión. Decide qué pantalla se muestra al abrir la app.
enum AuthStatus { desconocido, autenticado, noAutenticado }

/// Maneja el inicio y cierre de sesión y la restauración de la sesión guardada.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._api, this._storage);

  final ApiService _api;
  final StorageService _storage;

  AuthStatus _estado = AuthStatus.desconocido;
  AppUser? _usuario;
  String? _token;
  bool _cargando = false;
  String? _error;

  AuthStatus get estado => _estado;
  AppUser? get usuario => _usuario;
  String? get token => _token;
  bool get cargando => _cargando;
  String? get error => _error;

  /// Se ejecuta al abrir la app. Si hay una sesión guardada la valida contra
  /// el servidor:
  /// * token válido        -> entra directo a la tienda.
  /// * token expirado      -> borra la sesión y pide iniciar sesión de nuevo.
  /// * sin conexión        -> conserva la sesión guardada (modo tolerante).
  Future<void> intentarSesionGuardada() async {
    final token = await _storage.leerToken();
    final guardado = await _storage.leerUsuario();

    if (token == null || guardado == null) {
      _estado = AuthStatus.noAutenticado;
      notifyListeners();
      return;
    }

    _token = token;
    _usuario = guardado;
    try {
      _usuario = await _api.obtenerUsuarioActual(token);
      await _storage.guardarSesion(token, _usuario!);
      _estado = AuthStatus.autenticado;
    } on ApiException catch (e) {
      if (e.esNoAutorizado) {
        await _storage.borrarSesion();
        _token = null;
        _usuario = null;
        _estado = AuthStatus.noAutenticado;
      } else {
        _estado = AuthStatus.autenticado;
      }
    }
    notifyListeners();
  }

  /// Inicia sesión. Devuelve true si fue exitoso; si no, [error] contiene el motivo.
  Future<bool> iniciarSesion(String usuario, String password) async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      final sesion = await _api.login(usuario, password);
      _token = sesion.token;
      _usuario = sesion.user;
      await _storage.guardarSesion(sesion.token, sesion.user);
      _estado = AuthStatus.autenticado;
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Cierra la sesión y borra los datos guardados.
  Future<void> cerrarSesion() async {
    await _storage.borrarSesion();
    _token = null;
    _usuario = null;
    _error = null;
    _estado = AuthStatus.noAutenticado;
    notifyListeners();
  }
}
