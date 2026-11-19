# Guía de trabajo colaborativo en GitHub

## Ramas

| Rama | Propósito |
|---|---|
| `main` | Versión estable. Solo recibe cambios mediante Pull Request. |
| `develop` | Integración del trabajo del equipo. |
| `feature/<nombre>` | Una funcionalidad nueva (por ejemplo `feature/carrito`). |
| `fix/<nombre>` | Corrección de un error. |
| `docs/<nombre>` | Cambios de documentación. |

## Flujo de trabajo

1. Crear un Issue que describa la tarea y asignarlo a un integrante.
2. Actualizar la rama base: `git checkout develop && git pull`.
3. Crear la rama de trabajo: `git checkout -b feature/carrito`.
4. Programar y hacer commits pequeños y frecuentes.
5. Subir la rama: `git push -u origin feature/carrito`.
6. Abrir un Pull Request hacia `develop` usando la plantilla del repositorio.
7. Otro integrante revisa, comenta y aprueba.
8. Se hace merge y se elimina la rama.

## Convención de commits

Formato: `tipo: descripción corta en infinitivo`.

| Tipo | Uso |
|---|---|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de error |
| `docs` | Documentación |
| `refactor` | Reorganización sin cambiar el comportamiento |
| `test` | Pruebas |
| `chore` | Configuración y mantenimiento |

Ejemplos:

```
feat: agregar pantalla de carrito
fix: evitar que la cantidad supere el stock
docs: actualizar README con instrucciones de instalación
```

## Colaboradores

| Integrante | Número de control |
|---|---|
| Edgar Axel Sandoval Hernández (propietario del repositorio) | 22620093 |
| Yeni Daniela Ojeda Gómez | C22620155 |

Para agregar a un colaborador: repositorio, Settings, Collaborators, Add people, escribir su usuario de GitHub y enviar la invitación. La persona debe aceptarla desde su correo o desde GitHub.

## Reparto de trabajo sugerido

| Integrante | Módulo |
|---|---|
| Edgar Axel | Núcleo, servicios y autenticación: `core/`, `ApiService`, `AuthProvider`, login, perfil y colección de Postman |
| Yeni Daniela | Catálogo y carrito: `ProductProvider`, `CartProvider`, `StorageService`, pantallas de catálogo, detalle y carrito, y diseño en Figma |

Las pruebas y la documentación se reparten entre ambos.

## Resolución de conflictos

1. `git checkout develop && git pull`
2. `git checkout feature/mi-rama && git merge develop`
3. Resolver los marcadores `<<<<<<<` en cada archivo en conflicto.
4. `git add .` y `git commit`.
5. Volver a subir la rama.

## Reglas del equipo

- No hacer push directo a `main`.
- Todo Pull Request necesita al menos una aprobación.
- El CI (`flutter analyze` y `flutter test`) debe pasar antes del merge.
- No subir llaves, contraseñas ni archivos generados (`build/`, `.dart_tool/`).
