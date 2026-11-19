import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';

/// Criterios de ordenamiento del catálogo.
enum OrdenProductos { nombre, precioAscendente, precioDescendente, calificacion }

/// Descarga el catálogo y aplica búsqueda, filtro por etiqueta y ordenamiento.
///
/// Los filtros se aplican en memoria sobre la lista ya descargada, por lo que
/// responden al instante sin hacer nuevas peticiones.
class ProductProvider extends ChangeNotifier {
  ProductProvider(this._api);

  final ApiService _api;

  List<Product> _todos = [];
  bool _cargando = false;
  String? _error;
  String _busqueda = '';
  String? _etiqueta;
  OrdenProductos _orden = OrdenProductos.nombre;

  bool get cargando => _cargando;
  String? get error => _error;
  bool get sinDatos => _todos.isEmpty;
  String? get etiquetaSeleccionada => _etiqueta;
  OrdenProductos get orden => _orden;

  /// Etiquetas disponibles (una por producto) para construir los filtros.
  List<String> get etiquetas {
    final conjunto = _todos.map((p) => p.etiquetaPrincipal).toSet();
    return conjunto.toList()..sort();
  }

  /// Lista final que ve el usuario: busca, filtra y ordena.
  List<Product> get productos {
    final texto = _busqueda.toLowerCase();
    final lista = _todos.where((p) {
      final coincideTexto = texto.isEmpty ||
          p.title.toLowerCase().contains(texto) ||
          p.tags.any((t) => t.toLowerCase().contains(texto));
      final coincideEtiqueta =
          _etiqueta == null || p.etiquetaPrincipal == _etiqueta;
      return coincideTexto && coincideEtiqueta;
    }).toList();

    switch (_orden) {
      case OrdenProductos.nombre:
        lista.sort((a, b) => a.title.compareTo(b.title));
      case OrdenProductos.precioAscendente:
        lista.sort((a, b) => a.precioFinal.compareTo(b.precioFinal));
      case OrdenProductos.precioDescendente:
        lista.sort((a, b) => b.precioFinal.compareTo(a.precioFinal));
      case OrdenProductos.calificacion:
        lista.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return lista;
  }

  /// Descarga el catálogo desde la API.
  Future<void> cargarProductos() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _todos = await _api.obtenerProductos();
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void establecerBusqueda(String texto) {
    _busqueda = texto.trim();
    notifyListeners();
  }

  /// Selecciona una etiqueta; si se vuelve a tocar la misma, se quita el filtro.
  void seleccionarEtiqueta(String? etiqueta) {
    _etiqueta = _etiqueta == etiqueta ? null : etiqueta;
    notifyListeners();
  }

  void establecerOrden(OrdenProductos orden) {
    _orden = orden;
    notifyListeners();
  }
}
