/// Error controlado de la capa de red.
///
/// Traduce los fallos técnicos (sin internet, tiempo agotado, códigos HTTP) a
/// mensajes comprensibles que la interfaz puede mostrar directamente.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  /// Indica que el token es inválido o expiró.
  bool get esNoAutorizado => statusCode == 401 || statusCode == 403;

  @override
  String toString() => message;
}
