import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Barra de búsqueda Clean Tech con fondo blanco, bordes redondeados y botón limpiar.
class BuscadorProductos extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const BuscadorProductos({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: SearchBar(
        controller: controller,
        hintText: 'Buscar componentes por nombre...',
        hintStyle: const WidgetStatePropertyAll(
          TextStyle(
            color: AppTheme.textoSecundario,
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            color: AppTheme.textoPrincipal,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: const Icon(
          Icons.search,
          color: AppTheme.primario,
          size: 20,
        ),
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: const WidgetStatePropertyAll(AppTheme.fondoTarjeta),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppTheme.borde, width: 1),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12),
        ),
        onChanged: onChanged,
        trailing: [
          if (controller.text.isNotEmpty)
            IconButton(
              tooltip: 'Limpiar búsqueda',
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.close,
                size: 18,
                color: AppTheme.textoSecundario,
              ),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            ),
        ],
      ),
    );
  }
}
