import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';
import '../utils/formato.dart';
import '../widgets/estado_stock_badge.dart';
import '../widgets/producto_imagen.dart';

/// Ficha técnica del producto con diseño Clean Tech E-commerce.
class DetalleScreen extends StatelessWidget {
  final Producto producto;

  const DetalleScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ficha técnica',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final esAncho = constraints.maxWidth >= 820;
          final imagen = _ImagenPrincipal(producto: producto);
          final info = _Informacion(producto: producto);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: esAncho ? 28 : 16,
              vertical: esAncho ? 24 : 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: esAncho
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: imagen),
                          const SizedBox(width: 28),
                          Expanded(flex: 6, child: info),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          imagen,
                          const SizedBox(height: 16),
                          info,
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ImagenPrincipal extends StatelessWidget {
  final Producto producto;
  const _ImagenPrincipal({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.fondoTarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borde),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Hero(
            tag: 'img-${producto.id}',
            child: ProductoImagen(producto: producto, iconSize: 110),
          ),
        ),
      ),
    );
  }
}

class _Informacion extends StatelessWidget {
  final Producto producto;
  const _Informacion({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado del producto y precio
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.fondoTarjeta,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borde),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categoría y estado de inventario
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primario.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          producto.categoria.icono,
                          size: 14,
                          color: AppTheme.primario,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          producto.categoria.nombre,
                          style: const TextStyle(
                            color: AppTheme.primario,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  EstadoStockBadge(
                    disponible: producto.disponible,
                    detallado: true,
                  ),
                  if (producto.disponible)
                    Text(
                      '(${producto.stock} unid.)',
                      style: const TextStyle(
                        color: AppTheme.textoSecundario,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Nombre completo del producto
              Text(
                producto.nombre,
                style: const TextStyle(
                  color: AppTheme.textoPrincipal,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 14),

              // Precio estimado destacado
              const Text(
                'PRECIO ESTIMADO DE REFERENCIA',
                style: TextStyle(
                  color: AppTheme.textoSecundario,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatoSoles(producto.precio),
                style: const TextStyle(
                  color: AppTheme.acento,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Descripción técnica
        _Seccion(
          titulo: 'Descripción técnica',
          icono: Icons.description_outlined,
          child: Text(
            producto.descripcion,
            style: const TextStyle(
              color: AppTheme.textoPrincipal,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ),

        // Características principales
        _Seccion(
          titulo: 'Características principales',
          icono: Icons.fact_check_outlined,
          child: producto.caracteristicas.isEmpty
              ? const Text(
                  'No se registraron características adicionales.',
                  style: TextStyle(
                    color: AppTheme.textoSecundario,
                    fontSize: 13,
                  ),
                )
              : Column(
                  children: [
                    for (final c in producto.caracteristicas)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: AppTheme.disponible,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                c,
                                style: const TextStyle(
                                  color: AppTheme.textoPrincipal,
                                  fontSize: 13.5,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 6),

        // Botón Volver al catálogo
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Volver al catálogo'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bloque con título para la ficha técnica (reutilizable).
class _Seccion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Widget child;

  const _Seccion({
    required this.titulo,
    required this.icono,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.fondoTarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: AppTheme.primario, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: AppTheme.textoPrincipal,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          child,
        ],
      ),
    );
  }
}
