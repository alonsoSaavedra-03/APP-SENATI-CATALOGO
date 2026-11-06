import 'package:flutter/material.dart';

import '../models/categoria.dart';
import '../theme/app_theme.dart';

/// Fila horizontal de chips Material Design 3 para filtrar por categoría.
/// `seleccionada == null` representa el filtro «Todos».
class CategoriaChips extends StatelessWidget {
  final Categoria? seleccionada;
  final ValueChanged<Categoria?> onSeleccionar;

  const CategoriaChips({
    super.key,
    required this.seleccionada,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    final opciones = <(String, IconData, Categoria?)>[
      ('Todos', Icons.grid_view_rounded, null),
      for (final c in Categoria.values) (c.nombre, c.icono, c),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: opciones.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (texto, icono, categoria) = opciones[i];
          final activo = categoria == seleccionada;

          return ChoiceChip(
            avatar: Icon(
              icono,
              size: 16,
              color: activo ? Colors.white : AppTheme.textoSecundario,
            ),
            label: Text(texto),
            labelStyle: TextStyle(
              color: activo ? Colors.white : AppTheme.textoPrincipal,
              fontWeight: activo ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
            selected: activo,
            showCheckmark: false,
            backgroundColor: AppTheme.fondoTarjeta,
            selectedColor: AppTheme.primario,
            surfaceTintColor: Colors.transparent,
            side: BorderSide(
              color: activo ? AppTheme.primario : AppTheme.borde,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            onSelected: (_) => onSeleccionar(categoria),
          );
        },
      ),
    );
  }
}
