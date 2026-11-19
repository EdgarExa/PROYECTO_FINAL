import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

/// Catálogo de productos: búsqueda, filtros por etiqueta, ordenamiento y
/// actualización con "jalar para refrescar".
///
/// Estados de la pantalla: cargando, error con reintento, lista vacía y lista.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    // Se difiere al terminar el primer frame para no notificar durante build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final productos = context.read<ProductProvider>();
      if (productos.sinDatos) productos.cargarProductos();
    });
  }

  static const Map<OrdenProductos, String> _nombresOrden = {
    OrdenProductos.nombre: 'Nombre (A-Z)',
    OrdenProductos.precioAscendente: 'Precio: menor a mayor',
    OrdenProductos.precioDescendente: 'Precio: mayor a menor',
    OrdenProductos.calificacion: 'Mejor calificados',
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final lista = provider.productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.nombreApp),
        actions: [
          PopupMenuButton<OrdenProductos>(
            tooltip: 'Ordenar',
            icon: const Icon(Icons.sort),
            initialValue: provider.orden,
            onSelected: provider.establecerOrden,
            itemBuilder: (_) => [
              for (final entrada in _nombresOrden.entries)
                PopupMenuItem(value: entrada.key, child: Text(entrada.value)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              onChanged: provider.establecerBusqueda,
              decoration: const InputDecoration(
                hintText: 'Buscar producto',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
            ),
          ),
          if (provider.etiquetas.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: provider.etiquetas.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final etiqueta = provider.etiquetas[i];
                  return Center(
                    child: FilterChip(
                      label: Text(capitalizar(etiqueta)),
                      selected: provider.etiquetaSeleccionada == etiqueta,
                      onSelected: (_) => provider.seleccionarEtiqueta(etiqueta),
                    ),
                  );
                },
              ),
            ),
          Expanded(child: _cuerpo(provider, lista.length)),
        ],
      ),
    );
  }

  Widget _cuerpo(ProductProvider provider, int cantidad) {
    if (provider.cargando && provider.sinDatos) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null && provider.sinDatos) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 56),
              const SizedBox(height: 12),
              Text(provider.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: provider.cargarProductos,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    if (cantidad == 0) {
      return const Center(child: Text('No se encontraron productos'));
    }

    final productos = provider.productos;
    return RefreshIndicator(
      onRefresh: provider.cargarProductos,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemCount: productos.length,
        itemBuilder: (_, i) => ProductCard(producto: productos[i]),
      ),
    );
  }
}
