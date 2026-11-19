/// Producto del catálogo de abarrotes.
///
/// Se construye a partir del JSON que entrega el endpoint
/// `GET /products/category/groceries`.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.brand,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final String brand;
  final String thumbnail;

  /// Precio de lista en dólares (sin descuento).
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;

  /// Precio con el descuento aplicado, en dólares.
  double get precioFinal => price * (1 - discountPercentage / 100);

  bool get tieneDescuento => discountPercentage > 0;

  /// Etiqueta principal usada para filtrar el catálogo.
  String get etiquetaPrincipal => tags.isNotEmpty ? tags.first : 'otros';

  /// Crea un producto desde el JSON de la API. Los campos opcionales reciben
  /// valores por defecto para evitar errores si el servidor omite alguno.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Sin nombre',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] as num? ?? 0).toDouble(),
      rating: (json['rating'] as num? ?? 0).toDouble(),
      stock: (json['stock'] as num? ?? 0).toInt(),
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((etiqueta) => etiqueta.toString())
          .toList(),
    );
  }

  /// Serializa el producto (se usa para guardar el carrito en el dispositivo).
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'brand': brand,
        'thumbnail': thumbnail,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'tags': tags,
      };
}
