import 'package:flutter/material.dart';

/// Imagen de red con indicador de carga e ícono de respaldo si falla.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, this.fit = BoxFit.contain});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _Respaldo();
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, error, stack) => const _Respaldo(),
    );
  }
}

class _Respaldo extends StatelessWidget {
  const _Respaldo();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_not_supported_outlined, size: 40),
    );
  }
}
