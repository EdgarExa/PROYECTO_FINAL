import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

/// Carrito de compras: lista de líneas, total y confirmación del pedido.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  /// Pide confirmación, registra el pedido (simulado) y vacía el carrito.
  Future<void> _confirmarPedido(BuildContext context) async {
    final carrito = context.read<CartProvider>();
    final total = carrito.total;
    final articulos = carrito.totalArticulos;

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar pedido'),
        content: Text(
            '$articulos artículos por un total de ${formatearPrecio(total)}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmado != true || !context.mounted) return;

    // La API de prueba no guarda pedidos, así que el folio se genera localmente.
    final folio = 'AB-${DateTime.now().millisecondsSinceEpoch % 1000000}';
    carrito.vaciar();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, size: 48, color: Colors.green),
        title: const Text('Pedido registrado'),
        content: Text('Tu folio es $folio.\nTotal: ${formatearPrecio(total)}'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CartProvider>();
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi carrito'),
        actions: [
          if (!carrito.vacio)
            IconButton(
              tooltip: 'Vaciar carrito',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: carrito.vaciar,
            ),
        ],
      ),
      body: carrito.vacio
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 72),
                  SizedBox(height: 12),
                  Text('Tu carrito está vacío'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: carrito.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) =>
                        CartItemTile(item: carrito.items[i]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: tema.colorScheme.surfaceContainerHighest,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total (${carrito.totalArticulos} artículos)',
                                style: tema.textTheme.titleMedium),
                            Text(
                              formatearPrecio(carrito.total),
                              style: tema.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: tema.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => _confirmarPedido(context),
                            child: const Text('Confirmar pedido'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
