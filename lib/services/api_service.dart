import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants.dart';
import '../models/app_user.dart';
import '../models/auth_session.dart';
import '../models/product.dart';
import 'api_exception.dart';

/// Cliente HTTP de la aplicación. Es la única clase que habla con el servidor.
///
/// Endpoints consumidos (API DummyJSON):
/// * `POST /auth/login`                    inicio de sesión
/// * `GET  /auth/me`                       datos del usuario autenticado
/// * `GET  /products/category/groceries`   catálogo de abarrotes
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const Duration _tiempoMaximo = Duration(seconds: 15);

  Uri _uri(String ruta, [Map<String, String>? parametros]) {
    return Uri.parse('${AppConstants.baseUrl}$ruta')
        .replace(queryParameters: parametros);
  }

  /// Inicia sesión y devuelve el usuario con su token.
  Future<AuthSession> login(String usuario, String password) async {
    try {
      final json = await _ejecutar(
        () => _client.post(
          _uri('/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': usuario,
            'password': password,
            'expiresInMins': 1440,
          }),
        ),
      );
      // Según la versión de la API el token llega como accessToken o token.
      final token = (json['accessToken'] ?? json['token']) as String?;
      if (token == null) {
        throw ApiException('El servidor no devolvió un token de acceso.');
      }
      return AuthSession(user: AppUser.fromJson(json), token: token);
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        throw ApiException('Usuario o contraseña incorrectos.',
            statusCode: 400);
      }
      rethrow;
    }
  }

  /// Consulta el perfil del usuario dueño del token (endpoint protegido).
  Future<AppUser> obtenerUsuarioActual(String token) async {
    final json = await _ejecutar(
      () => _client.get(
        _uri('/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return AppUser.fromJson(json);
  }

  /// Descarga todos los productos de la categoría de abarrotes.
  Future<List<Product>> obtenerProductos() async {
    final json = await _ejecutar(
      () => _client.get(
        _uri('/products/category/${AppConstants.categoriaAbarrotes}',
            {'limit': '100'}),
      ),
    );
    final lista = json['products'] as List<dynamic>? ?? [];
    return lista
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Ejecuta una petición, valida el código HTTP y decodifica el JSON.
  /// Convierte cualquier fallo en una [ApiException] con mensaje legible.
  Future<Map<String, dynamic>> _ejecutar(
    Future<http.Response> Function() peticion,
  ) async {
    try {
      final respuesta = await peticion().timeout(_tiempoMaximo);
      final cuerpo = respuesta.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(utf8.decode(respuesta.bodyBytes));

      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        return cuerpo as Map<String, dynamic>;
      }
      final detalle = cuerpo is Map<String, dynamic>
          ? cuerpo['message'] as String?
          : null;
      throw ApiException(
        detalle ?? 'Error del servidor (${respuesta.statusCode}).',
        statusCode: respuesta.statusCode,
      );
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('El servidor tardó demasiado en responder.');
    } on FormatException {
      throw ApiException('La respuesta del servidor no es válida.');
    } on TypeError {
      throw ApiException('La respuesta del servidor no tiene el formato esperado.');
    } catch (_) {
      // Fallo de conexión: SocketException en móvil, ClientException en web.
      // No se importa dart:io para que el mismo código funcione también en web.
      throw ApiException('Sin conexión a internet o servidor no disponible.');
    }
  }
}
