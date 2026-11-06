import 'categoria.dart';

/// Modelo de un componente del catálogo.
class Producto {
  final String id;
  final String nombre;
  final Categoria categoria;
  final double precio;
  final String descripcion;

  /// Características principales (lista de viñetas en la ficha técnica).
  final List<String> caracteristicas;

  /// Imagen local incluida en la app (assets/images/...).
  final String? imagenAsset;

  /// Imagen remota opcional ingresada por el usuario.
  final String? imagenUrl;

  /// Unidades en almacén. 0 = no disponible.
  final int stock;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.descripcion,
    this.caracteristicas = const [],
    this.imagenAsset,
    this.imagenUrl,
    this.stock = 0,
  });

  bool get disponible => stock > 0;
}
