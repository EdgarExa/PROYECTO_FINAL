import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';
import 'product_image.dart';

/// Tarjeta de producto para la cuadrícula del catálogo.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.producto});

  final Product producto;

  void _agregar(BuildContext context) {
    final agregado = context.read<CartProvider>().agregar(producto);
    final mensaje = agregado
        ? '${producto.title} agregado al carrito'
        : 'Solo hay ${producto.stock} piezas disponibles';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 1),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(producto: producto),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Hero(
                        tag: 'producto-${producto.id}',
                        child: ProductImage(url: producto.thumbnail),
                      ),
                    ),
                  ),
                  if (producto.tieneDescuento)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: tema.colorScheme.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${producto.discountPercentage.round()}%',
                          style: TextStyle(
                            color: tema.colorScheme.onError,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: tema.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatearPrecio(producto.precioFinal),
                          style: tema.textTheme.titleMedium?.copyWith(
                            color: tema.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (producto.tieneDescuento)
                          Text(
                            formatearPrecio(producto.price),
                            style: tema.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Agregar al carrito',
                    onPressed: producto.stock > 0
                        ? () => _agregar(context)
                        : null,
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
