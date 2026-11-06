import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Etiqueta de disponibilidad Clean Tech (verde = disponible, gris neutro = agotado).
class EstadoStockBadge extends StatelessWidget {
  final bool disponible;

  /// Si es true muestra el texto largo usado en la ficha técnica.
  final bool detallado;

  const EstadoStockBadge({
    super.key,
    required this.disponible,
    this.detallado = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = disponible ? AppTheme.disponible : AppTheme.textoSecundario;
    final bgColor = disponible
        ? const Color(0xFFEBF3ED)
        : const Color(0xFFF0F2F5);
    final borderColor = disponible
        ? AppTheme.disponible.withValues(alpha: 0.30)
        : AppTheme.borde;

    final texto = disponible
        ? (detallado ? 'Stock disponible en almacén' : 'Disponible')
        : (detallado ? 'Sin stock en almacén' : 'Agotado');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: detallado ? 10 : 8,
        vertical: detallado ? 5 : 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            disponible ? Icons.check_circle : Icons.remove_circle_outline,
            size: detallado ? 15 : 12,
            color: color,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              texto,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: detallado ? 12.5 : 11,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
