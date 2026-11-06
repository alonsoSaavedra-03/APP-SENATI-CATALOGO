import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';

/// Muestra la imagen de un producto: URL > asset > ilustración por categoría.
/// Si la imagen falla al cargar, también usa la ilustración de respaldo.
class ProductoImagen extends StatelessWidget {
  final Producto producto;
  final BoxFit fit;
  final double iconSize;

  const ProductoImagen({
    super.key,
    required this.producto,
    this.fit = BoxFit.contain,
    this.iconSize = 52,
  });

  @override
  Widget build(BuildContext context) {
    final url = producto.imagenUrl;
    final asset = producto.imagenAsset;

    Widget respaldo(BuildContext _, Object _, StackTrace? _) =>
        _Ilustracion(producto: producto, iconSize: iconSize);

    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: fit,
        alignment: Alignment.center,
        errorBuilder: respaldo,
        loadingBuilder: (context, child, progreso) => progreso == null
            ? child
            : const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primario,
                  ),
                ),
              ),
      );
    }
    if (asset != null) {
      return Image.asset(
        asset,
        fit: fit,
        alignment: Alignment.center,
        errorBuilder: respaldo,
      );
    }
    return _Ilustracion(producto: producto, iconSize: iconSize);
  }
}

class _Ilustracion extends StatelessWidget {
  final Producto producto;
  final double iconSize;

  const _Ilustracion({required this.producto, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.fondoGeneral,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(
        producto.categoria.icono,
        size: iconSize,
        color: AppTheme.primario.withValues(alpha: 0.55),
      ),
    );
  }
}
