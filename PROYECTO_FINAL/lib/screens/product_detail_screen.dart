import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_image.dart';

/// Detalle de un producto con selector de cantidad.
///
/// La cantidad elegida es estado local de esta pantalla (_cantidad); el carrito
/// solo se modifica al presionar "Agregar al carrito".
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.producto});

  final Product producto;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _cantidad = 1;

  void _agregar() {
    final carrito = context.read<CartProvider>();
    final completo = carrito.agregar(widget.producto, cantidad: _cantidad);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(completo
          ? 'Agregaste $_cantidad x ${widget.producto.title}'
          : 'Solo hay ${widget.producto.stock} piezas disponibles'),
    ));
    if (completo) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.producto;
    final tema = Theme.of(context);
    final agotado = p.stock <= 0;

    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 240,
            child: Hero(
              tag: 'producto-${p.id}',
              child: ProductImage(url: p.thumbnail),
            ),
          ),
          const SizedBox(height: 16),
          Text(p.title,
              style: tema.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(p.rating.toStringAsFixed(1)),
              const SizedBox(width: 16),
              Chip(label: Text(capitalizar(p.etiquetaPrincipal))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatearPrecio(p.precioFinal),
                style: tema.textTheme.headlineMedium?.copyWith(
                  color: tema.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              if (p.tieneDescuento)
                Text(
                  formatearPrecio(p.price),
                  style: tema.textTheme.titleMedium
                      ?.copyWith(decoration: TextDecoration.lineThrough),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            agotado ? 'Producto agotado' : '${p.stock} piezas disponibles',
            style: TextStyle(
              color: agotado ? tema.colorScheme.error : null,
            ),
          ),
          const SizedBox(height: 16),
          Text('Descripción', style: tema.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(p.description),
          const SizedBox(height: 24),
          if (!agotado)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  onPressed:
                      _cantidad > 1 ? () => setState(() => _cantidad--) : null,
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('$_cantidad', style: tema.textTheme.titleLarge),
                ),
                IconButton.outlined(
                  onPressed: _cantidad < p.stock
                      ? () => setState(() => _cantidad++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: agotado ? null : _agregar,
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(agotado
                ? 'No disponible'
                : 'Agregar al carrito  |  ${formatearPrecio(p.precioFinal * _cantidad)}'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
