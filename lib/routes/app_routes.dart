import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../screens/detalle_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

/// Rutas con nombre de la aplicación.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/';
  static const String detalle = '/detalle';

  static Route<dynamic> generarRuta(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case detalle:
        // El producto seleccionado viaja como argumento de la ruta.
        final producto = settings.arguments as Producto;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DetalleScreen(producto: producto),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Página no encontrada')),
          ),
        );
    }
  }
}
