import 'package:intl/intl.dart';

import 'constants.dart';

final NumberFormat _formatoMoneda =
    NumberFormat.currency(locale: 'es_MX', symbol: r'$', decimalDigits: 2);

/// Convierte un precio en dólares (como lo entrega la API) a pesos mexicanos
/// con formato de moneda, por ejemplo `$36.00`.
String formatearPrecio(double precioUsd) {
  return _formatoMoneda.format(precioUsd * AppConstants.tasaUsdAMxn);
}

/// Devuelve el texto con la primera letra en mayúscula.
String capitalizar(String texto) {
  if (texto.isEmpty) return texto;
  return texto[0].toUpperCase() + texto.substring(1);
}
