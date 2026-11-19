import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/app_user.dart';
import '../models/cart_item.dart';

/// Persistencia local (clave-valor) con SharedPreferences.
///
/// Guarda la sesión (token y usuario) y el carrito para que sobrevivan al
/// cierre de la aplicación.
class StorageService {
  Future<void> guardarSesion(String token, AppUser usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.claveToken, token);
    await prefs.setString(
        AppConstants.claveUsuario, jsonEncode(usuario.toJson()));
  }

  Future<String?> leerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.claveToken);
  }

  Future<AppUser?> leerUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(AppConstants.claveUsuario);
    if (texto == null) return null;
    return AppUser.fromJson(jsonDecode(texto) as Map<String, dynamic>);
  }

  Future<void> borrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.claveToken);
    await prefs.remove(AppConstants.claveUsuario);
  }

  Future<void> guardarCarrito(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(items.map((i) => i.toJson()).toList());
    await prefs.setString(AppConstants.claveCarrito, texto);
  }

  /// Lee el carrito guardado. Si los datos están dañados devuelve una lista vacía.
  Future<List<CartItem>> leerCarrito() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(AppConstants.claveCarrito);
    if (texto == null) return [];
    try {
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
