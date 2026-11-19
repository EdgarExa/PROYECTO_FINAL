import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_final/models/product.dart';
import 'package:proyecto_final/providers/cart_provider.dart';
import 'package:proyecto_final/services/storage_service.dart';

Product _producto({
  int id = 1,
  double precio = 10,
  double descuento = 0,
  int stock = 5,
}) {
  return Product(
    id: id,
    title: 'Producto $id',
    description: 'Descripción de prueba',
    category: 'groceries',
    brand: '',
    thumbnail: '',
    price: precio,
    discountPercentage: descuento,
    rating: 4.5,
    stock: stock,
    tags: const ['prueba'],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CartProvider carrito;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    carrito = CartProvider(StorageService());
  });

  group('Product', () {
    test('fromJson aplica valores por defecto y calcula el precio final', () {
      final p = Product.fromJson({
        'id': 7,
        'title': 'Leche',
        'price': 20,
        'discountPercentage': 10,
      });
      expect(p.stock, 0);
      expect(p.tags, isEmpty);
      expect(p.precioFinal, closeTo(18, 0.001));
    });
  });

  group('CartProvider', () {
    test('agrega productos y calcula el total con descuento', () {
      carrito.agregar(_producto(id: 1, precio: 10, descuento: 50), cantidad: 2);
      carrito.agregar(_producto(id: 2, precio: 4));
      expect(carrito.totalArticulos, 3);
      expect(carrito.total, closeTo(14, 0.001));
    });

    test('no permite superar el stock disponible', () {
      final p = _producto(stock: 3);
      expect(carrito.agregar(p, cantidad: 5), isFalse);
      expect(carrito.cantidadDe(p.id), 3);
      carrito.incrementar(p.id);
      expect(carrito.cantidadDe(p.id), 3);
    });

    test('decrementar a cero elimina la línea', () {
      final p = _producto();
      carrito.agregar(p);
      carrito.decrementar(p.id);
      expect(carrito.vacio, isTrue);
    });

    test('vaciar elimina todas las líneas', () {
      carrito.agregar(_producto(id: 1));
      carrito.agregar(_producto(id: 2));
      carrito.vaciar();
      expect(carrito.totalArticulos, 0);
    });

    test('persiste y restaura el carrito', () async {
      carrito.agregar(_producto(id: 9), cantidad: 2);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final otro = CartProvider(StorageService());
      await otro.cargar();
      expect(otro.cantidadDe(9), 2);
    });
  });
}
