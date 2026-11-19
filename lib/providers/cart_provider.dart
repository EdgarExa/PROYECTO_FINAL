import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

/// Lógica del carrito de compras.
///
/// Reglas de negocio:
/// * La cantidad de un producto nunca supera su existencia (stock).
/// * Si la cantidad baja a cero, la línea se elimina.
/// * Cada cambio se guarda en el dispositivo para no perder el carrito.
class CartProvider extends ChangeNotifier {
  CartProvider(this._storage);

  final StorageService _storage;

  /// Líneas del carrito indexadas por el id del producto.
  final Map<int, CartItem> _lineas = {};

  List<CartItem> get items => _lineas.values.toList();
  bool get vacio => _lineas.isEmpty;

  /// Cantidad total de artículos (suma de cantidades).
  int get totalArticulos =>
      _lineas.values.fold(0, (suma, linea) => suma + linea.quantity);

  /// Total a pagar en dólares (se convierte a pesos al mostrarlo).
  double get total =>
      _lineas.values.fold(0.0, (suma, linea) => suma + linea.subtotal);

  int cantidadDe(int idProducto) => _lineas[idProducto]?.quantity ?? 0;

  /// Carga el carrito guardado en el dispositivo.
  Future<void> cargar() async {
    final guardado = await _storage.leerCarrito();
    _lineas
      ..clear()
      ..addEntries(guardado.map((l) => MapEntry(l.product.id, l)));
    notifyListeners();
  }

  /// Agrega [cantidad] unidades del producto.
  ///
  /// Devuelve false si se alcanzó el límite de existencias; en ese caso la
  /// cantidad queda fijada en el stock disponible.
  bool agregar(Product producto, {int cantidad = 1}) {
    final nueva = cantidadDe(producto.id) + cantidad;
    final permitida = nueva > producto.stock ? producto.stock : nueva;
    if (permitida <= 0) return false;

    _lineas[producto.id] = CartItem(product: producto, quantity: permitida);
    _guardarYNotificar();
    return nueva <= producto.stock;
  }

  void incrementar(int idProducto) {
    final linea = _lineas[idProducto];
    if (linea == null || linea.quantity >= linea.product.stock) return;
    _lineas[idProducto] = linea.copyWith(quantity: linea.quantity + 1);
    _guardarYNotificar();
  }

  void decrementar(int idProducto) {
    final linea = _lineas[idProducto];
    if (linea == null) return;
    if (linea.quantity <= 1) {
      _lineas.remove(idProducto);
    } else {
      _lineas[idProducto] = linea.copyWith(quantity: linea.quantity - 1);
    }
    _guardarYNotificar();
  }

  void eliminar(int idProducto) {
    _lineas.remove(idProducto);
    _guardarYNotificar();
  }

  void vaciar() {
    _lineas.clear();
    _guardarYNotificar();
  }

  void _guardarYNotificar() {
    unawaited(_storage.guardarCarrito(items));
    notifyListeners();
  }
}
