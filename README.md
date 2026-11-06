# Catálogo SENATI — Componentes de Hardware y Periféricos

Aplicación desarrollada en **Flutter** para la consulta, filtrado, búsqueda y registro de componentes de hardware y periféricos de los laboratorios de TI de **SENATI**, con sistema de **Login / Registro** y persistencia en formato **JSON** antes de ingresar al catálogo.

## Características principales

- **Autenticación con persistencia en JSON (`LoginScreen` y `AuthJsonService`)**:
  - Inicio de sesión (`Correo / Usuario` y `Contraseña`) y creación de nuevas cuentas (`Nombre completo`, `Correo / Usuario` y `Contraseña`).
  - Antes de ingresar al catálogo, los usuarios registrados, el historial de accesos y la sesión activa se serializan y guardan en formato JSON (`usuarios_sesion.json` / `assets/data/usuarios.json`).
  - Cuenta demo precargada:
    - **Usuario**: `admin@senati.pe`
    - **Contraseña**: `123456`
  - Visor interactivo del archivo JSON guardado integrado en la pantalla de Login y en el catálogo principal.
- **Catálogo adaptable (`HomeScreen`)**:
  - Diseño *Clean Tech E-commerce* con colores institucionales de SENATI (`#163D70` y `#E87524`).
  - Cuadrícula responsiva (2 columnas en móvil, 3 en tablet y hasta 5 en escritorio).
  - Buscador en tiempo real, filtros por categoría (*Hardware*, *Procesadores*, *Almacenamiento*, *Periféricos*) y ordenamiento por nombre o precio.
- **Ficha técnica (`DetalleScreen`)**:
  - Vista detallada con animación `Hero`, precio estimado en soles (`S/`), estado de stock en almacén y lista de características técnicas.
- **Registro de componentes (`RegistroProductoSheet`)**:
  - Formulario con validaciones para agregar nuevos productos al catálogo.

## Estructura del proyecto

```text
lib/
├── data/
│   └── productos_iniciales.dart     # Catálogo inicial de componentes
├── models/
│   ├── categoria.dart               # Enum de categorías con íconos
│   ├── producto.dart                # Modelo de producto del catálogo
│   └── usuario.dart                 # Modelo de usuario serializable a JSON
├── routes/
│   └── app_routes.dart              # Rutas (/login, /, /detalle)
├── screens/
│   ├── login_screen.dart            # Pantalla de Login y Registro con JSON
│   ├── home_screen.dart             # Pantalla principal del catálogo
│   └── detalle_screen.dart          # Ficha técnica del componente
├── services/
│   ├── auth_json_service.dart       # Servicio de autenticación y guardado JSON
│   ├── json_storage_io.dart         # Escritura/lectura de usuarios_sesion.json
│   └── json_storage_stub.dart       # Fallback en memoria para entorno web
├── theme/
│   └── app_theme.dart               # Tema institucional Clean Tech E-commerce
├── utils/
│   └── formato.dart                 # Formato de moneda en soles (S/)
├── widgets/                         # Componentes visuales reutilizables
└── main.dart                        # Punto de entrada de la aplicación
```

## Ejecución

```bash
flutter pub get
flutter run
```
