# PROYECTO_FINAL - Abarrotes Express

Aplicación móvil (Abarrotes Express) para una tienda de abarrotes, desarrollada con Flutter y probada en emuladores Android. Permite iniciar sesión, consultar el catálogo de productos, buscar y filtrar, armar un carrito de compras y confirmar un pedido.

## Funcionalidades

- Inicio de sesión contra una API real (`POST /auth/login`) con validación de formulario.
- Sesión persistente: al abrir la app se valida el token guardado (`GET /auth/me`).
- Catálogo de abarrotes (`GET /products/category/groceries`) con búsqueda, filtros por etiqueta y ordenamiento.
- Detalle de producto con selector de cantidad y control de existencias.
- Carrito con persistencia local, descuentos, total y confirmación de pedido con folio.
- Perfil de usuario y cierre de sesión.
- Manejo de errores: sin internet, tiempo agotado, credenciales inválidas y sesión expirada.

## Tecnologías y librerías

| Librería | Uso |
|---|---|
| `provider` | Manejo de estado (autenticación, catálogo y carrito) |
| `http` | Consumo de la API REST |
| `shared_preferences` | Persistencia local de sesión y carrito |
| `intl` | Formato de moneda en pesos mexicanos |

## Requisitos

- Flutter 3.22 o superior (Dart 3.3 o superior)
- Android Studio con un emulador Android (AVD) configurado
- Conexión a internet en el emulador

## Instalación

```bash
git clone https://github.com/EdgarExa/PROYECTO_FINAL.git
cd PROYECTO_FINAL
flutter pub get
flutter run
```

Si el repositorio no incluye las carpetas `android/` e `ios/`, genéralas con:

```bash
flutter create . --org mx.edu.proyectofinal --project-name proyecto_final
```

Para compilar en modo release, el archivo `android/app/src/main/AndroidManifest.xml` debe declarar el permiso de internet antes de la etiqueta `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Credenciales de prueba

| Usuario | Contraseña |
|---|---|
| `emilys` | `emilyspass` |

La pantalla de inicio de sesión incluye el botón "Usar credenciales de prueba".

## Estructura del proyecto

```
lib/
  main.dart                   Punto de entrada, providers y AuthGate
  core/                       Constantes, tema y formateadores
  models/                     Product, AppUser, CartItem, AuthSession
  services/                   ApiService, StorageService, ApiException
  providers/                  AuthProvider, ProductProvider, CartProvider
  screens/                    Pantallas de la aplicación
  widgets/                    Componentes reutilizables
test/                         Pruebas unitarias
docs/                         Documentación adicional
```

## Arquitectura

Se separa en capas para que cada archivo tenga una sola responsabilidad:

1. **Servicios**: hablan con el exterior (API y almacenamiento local).
2. **Modelos**: representan los datos y los convierten desde y hacia JSON.
3. **Providers**: contienen la lógica de negocio y notifican a la interfaz.
4. **Pantallas y widgets**: solo dibujan el estado y envían acciones al provider.

## API utilizada

Se consume [DummyJSON](https://dummyjson.com). Los precios llegan en dólares y la app los convierte a pesos con una tasa fija definida en `lib/core/constants.dart`. La API es de pruebas: no almacena pedidos, por lo que el folio se genera en el dispositivo.

## Pruebas de la API con Postman

En `docs/postman/` está la colección `PROYECTO_FINAL.postman_collection.json`. Se importa en Postman, se ejecuta primero la petición de login (guarda el token en una variable) y después las demás.

## Diseño en Figma

En `docs/figma/` están las pantallas diseñadas (SVG editables y vista previa en PNG). Los SVG se pueden arrastrar directamente a un archivo de Figma.

## Pruebas y análisis

```bash
flutter analyze
flutter test
```

## Documentación del código

Las clases y métodos públicos se documentan con comentarios `///`. Para generar la documentación HTML:

```bash
dart doc .
```

## Trabajo colaborativo

El flujo de ramas, convenciones de commits y revisión de código está descrito en [docs/GITHUB.md](docs/GITHUB.md).

## Datos académicos

Tecnológico Nacional de México, Instituto Tecnológico de Tlaxiaco. Ingeniería en Sistemas Computacionales, 7.º semestre (7US). Asignatura: Desarrollo de Aplicaciones Móviles. Docente: Ing. Vásquez Martínez Josué Israel.

## Autores

| Nombre | Número de control |
|---|---|
| Edgar Axel Sandoval Hernández | 22620093 |
| Yeni Daniela Ojeda Gómez | C22620155 |

## Licencia

Proyecto académico. Uso educativo.
