/// Constantes globales de la aplicación.
///
/// Centralizar estos valores evita "números mágicos" repartidos por el código
/// y permite cambiar, por ejemplo, la URL del servidor en un solo lugar.
class AppConstants {
  AppConstants._();

  /// Nombre comercial de la aplicación. Cámbialo aquí y se actualiza en toda la app.
  static const String nombreApp = 'Abarrotes Express';

  /// URL base de la API pública DummyJSON.
  static const String baseUrl = 'https://dummyjson.com';

  /// Categoría de la API que representa los productos de abarrotes.
  static const String categoriaAbarrotes = 'groceries';

  /// Tipo de cambio fijo usado para mostrar los precios (USD) en pesos mexicanos.
  static const double tasaUsdAMxn = 18.0;

  /// Claves usadas en SharedPreferences.
  static const String claveToken = 'auth_token';
  static const String claveUsuario = 'auth_user';
  static const String claveCarrito = 'cart_items';

  /// Credenciales de prueba publicadas por DummyJSON.
  static const String usuarioDemo = 'emilys';
  static const String passwordDemo = 'emilyspass';
}
