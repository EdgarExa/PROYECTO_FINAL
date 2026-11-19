import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'catalog_screen.dart';
import 'profile_screen.dart';

/// Contenedor principal con la barra de navegación inferior.
///
/// Usa IndexedStack para conservar el estado de cada pestaña (por ejemplo, el
/// texto de búsqueda y el desplazamiento del catálogo) al cambiar de una a otra.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  static const List<Widget> _pantallas = [
    CatalogScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // select: solo se reconstruye cuando cambia el total de artículos.
    final articulos =
        context.select<CartProvider, int>((c) => c.totalArticulos);

    return Scaffold(
      body: IndexedStack(index: _indice, children: _pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Tienda',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$articulos'),
              isLabelVisible: articulos > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              label: Text('$articulos'),
              isLabelVisible: articulos > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Carrito',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
