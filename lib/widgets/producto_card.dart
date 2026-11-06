import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';
import '../utils/formato.dart';
import 'estado_stock_badge.dart';
import 'producto_imagen.dart';

/// Tarjeta de producto Clean Tech E-commerce con estado hover discreto.
class ProductoCard extends StatefulWidget {
  final Producto producto;
  final VoidCallback onTap;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onTap,
  });

  @override
  State<ProductoCard> createState() => _ProductoCardState();
}

class _ProductoCardState extends State<ProductoCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final agotado = !producto.disponible;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppTheme.fondoTarjeta,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hover
                ? AppTheme.primario.withValues(alpha: 0.45)
                : AppTheme.borde,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF163D70)
                  .withValues(alpha: _hover ? 0.08 : 0.03),
              blurRadius: _hover ? 12 : 6,
              offset: Offset(0, _hover ? 4 : 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            hoverColor: AppTheme.primario.withValues(alpha: 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Imagen con proporción uniforme + 2. Etiqueta de disponibilidad
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.fondoTarjeta,
                      border: Border(
                        bottom: BorderSide(color: AppTheme.borde, width: 1),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Opacity(
                            opacity: agotado ? 0.55 : 1.0,
                            child: Hero(
                              tag: 'img-${producto.id}',
                              child: ProductoImagen(producto: producto),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: EstadoStockBadge(
                            disponible: producto.disponible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Contenido inferior con altura consistente
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. Categoría del componente
                      Row(
                        children: [
                          Icon(
                            producto.categoria.icono,
                            size: 13,
                            color: AppTheme.textoSecundario,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              producto.categoria.nombre.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.textoSecundario,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // 4. Nombre del producto limitado a 2 líneas con altura fija
                      SizedBox(
                        height: 38,
                        child: Text(
                          producto.nombre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textoPrincipal,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 5. Precio en S/. + 6. Indicador visual para acceder al detalle
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              formatoSoles(producto.precio),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: agotado
                                    ? AppTheme.textoSecundario
                                    : AppTheme.acento,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _hover
                                  ? AppTheme.primario
                                  : AppTheme.fondoGeneral,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _hover
                                    ? AppTheme.primario
                                    : AppTheme.borde,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ficha',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _hover
                                        ? Colors.white
                                        : AppTheme.primario,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 10,
                                  color: _hover
                                      ? Colors.white
                                      : AppTheme.primario,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
