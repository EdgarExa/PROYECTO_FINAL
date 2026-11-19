import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'product_image.dart';

/// Fila del carrito con controles para cambiar la cantidad o quitar el producto.
/// Deslizar hacia la izquierda también elimina la línea.
class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final carrito = context.read<CartProvider>();
    final producto = item.product;
    final tema = Theme.of(context);

    return Dismissible(
      key: ValueKey('carrito-${producto.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: tema.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: tema.colorScheme.onError),
      ),
      onDismissed: (_) => carrito.eliminar(producto.id),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: SizedBox(
          width: 56,
          height: 56,
          child: ProductImage(url: producto.thumbnail),
        ),
        title: Text(producto.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${formatearPrecio(producto.precioFinal)} c/u  |  '
          'Subtotal: ${formatearPrecio(item.subtotal)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Quitar una pieza',
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => carrito.decrementar(producto.id),
            ),
            Text('${item.quantity}', style: tema.textTheme.titleMedium),
            IconButton(
              tooltip: 'Agregar una pieza',
              icon: const Icon(Icons.add_circle_outline),
              onPressed: item.quantity < producto.stock
                  ? () => carrito.incrementar(producto.id)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
