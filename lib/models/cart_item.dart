import 'product.dart';

/// Línea del carrito: un producto y la cantidad que se desea comprar.
class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  /// Importe de la línea (precio con descuento por cantidad), en dólares.
  double get subtotal => product.precioFinal * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };
}
