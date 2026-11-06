import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Criterios de ordenamiento del catálogo.
enum OrdenCatalogo {
  recientes('Más recientes'),
  nombreAsc('Nombre (A - Z)'),
  precioMenor('Precio: menor a mayor'),
  precioMayor('Precio: mayor a menor');

  const OrdenCatalogo(this.etiqueta);
  final String etiqueta;
}

/// Barra de herramientas del catálogo con título, contador y selector de orden.
class CatalogoToolbar extends StatelessWidget {
  final int totalResultados;
  final OrdenCatalogo ordenActual;
  final ValueChanged<OrdenCatalogo> onOrdenChanged;

  const CatalogoToolbar({
    super.key,
    required this.totalResultados,
    required this.ordenActual,
    required this.onOrdenChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectorOrden = Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.fondoTarjeta,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borde),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<OrdenCatalogo>(
          key: const Key('selectorOrden'),
          value: ordenActual,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppTheme.textoSecundario,
          ),
          style: const TextStyle(
            color: AppTheme.textoPrincipal,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: AppTheme.fondoTarjeta,
          borderRadius: BorderRadius.circular(8),
          onChanged: (nuevo) {
            if (nuevo != null) onOrdenChanged(nuevo);
          },
          items: [
            for (final opcion in OrdenCatalogo.values)
              DropdownMenuItem(
                value: opcion,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sort_rounded,
                      size: 15,
                      color: AppTheme.textoSecundario,
                    ),
                    const SizedBox(width: 6),
                    Text(opcion.etiqueta),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final esEstrecho = constraints.maxWidth < 520;

        final tituloYContador = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
              child: Text(
                'Productos disponibles',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.textoPrincipal,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.borde.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalResultados resultado(s)',
                style: const TextStyle(
                  color: AppTheme.textoSecundario,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );

        if (esEstrecho) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tituloYContador,
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: selectorOrden,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: tituloYContador),
            const SizedBox(width: 12),
            selectorOrden,
          ],
        );
      },
    );
  }
}
