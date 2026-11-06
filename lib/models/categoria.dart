import 'package:flutter/material.dart';

/// Categorías disponibles para clasificar los componentes.
enum Categoria {
  hardware('Hardware', Icons.memory),
  procesadores('Procesadores', Icons.developer_board),
  almacenamiento('Almacenamiento', Icons.storage),
  perifericos('Periféricos', Icons.keyboard);

  const Categoria(this.nombre, this.icono);

  /// Texto visible para el usuario.
  final String nombre;

  /// Icono representativo de la categoría.
  final IconData icono;
}
