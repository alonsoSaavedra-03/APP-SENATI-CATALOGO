import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Banner destacado Clean Tech E-commerce con fondo azul institucional discreto.
class BannerCatalogo extends StatelessWidget {
  final int totalProductos;

  const BannerCatalogo({super.key, required this.totalProductos});

  @override
  Widget build(BuildContext context) {
    final esCompacto = MediaQuery.sizeOf(context).width < 600;

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: esCompacto ? 18 : 24,
        vertical: esCompacto ? 16 : 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            AppTheme.primario,
            Color(0xFF1D4B87),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(
          color: const Color(0xFF102E56),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.acento,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'LABORATORIOS TI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$totalProductos productos registrados en el catálogo',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Componentes y periféricos para tus prácticas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: esCompacto ? 17 : 20,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Consulta especificaciones técnicas, precios estimados y disponibilidad en almacén.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          if (!esCompacto) ...[
            const SizedBox(width: 20),
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                ),
              ),
              child: const Icon(
                Icons.developer_board_outlined,
                size: 36,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
