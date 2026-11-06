import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/categoria.dart';
import '../models/producto.dart';
import '../theme/app_theme.dart';

/// Formulario modal para registrar un componente (Dialog en pantallas anchas,
/// Bottom Sheet en dispositivos móviles).
/// Devuelve el [Producto] creado mediante `Navigator.pop`.
class RegistroProductoSheet extends StatefulWidget {
  const RegistroProductoSheet({super.key});

  /// Abre el formulario según el tamaño de pantalla y devuelve el producto registrado.
  static Future<Producto?> mostrar(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    if (ancho >= 720) {
      return showDialog<Producto>(
        context: context,
        builder: (_) => Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: const RegistroProductoSheet(),
          ),
        ),
      );
    }

    return showModalBottomSheet<Producto>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 600),
      builder: (_) => const RegistroProductoSheet(),
    );
  }

  @override
  State<RegistroProductoSheet> createState() => _RegistroProductoSheetState();
}

class _RegistroProductoSheetState extends State<RegistroProductoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _caracteristicasCtrl = TextEditingController();
  final _imagenCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '1');

  Categoria? _categoria;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _descripcionCtrl.dispose();
    _caracteristicasCtrl.dispose();
    _imagenCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  // ---------- Validaciones ----------

  String? _validarObligatorio(String? v, String campo) =>
      (v == null || v.trim().isEmpty) ? 'Ingresa $campo' : null;

  String? _validarPrecio(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa el precio';
    final precio = double.tryParse(v.trim());
    if (precio == null) return 'Precio inválido. Ejemplo: 450.00';
    if (precio <= 0) return 'El precio debe ser mayor a 0';
    if (precio > 100000) return 'El precio parece demasiado alto';
    return null;
  }

  String? _validarStock(String? v) {
    final n = int.tryParse(v?.trim() ?? '');
    if (n == null || n < 0) return 'Cantidad inválida';
    return null;
  }

  String? _validarUrl(String? v) {
    if (v == null || v.trim().isEmpty) return null; // opcional
    final uri = Uri.tryParse(v.trim());
    final ok = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return ok ? null : 'Ingresa una URL válida (http/https)';
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final producto = Producto(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nombre: _nombreCtrl.text.trim(),
      categoria: _categoria!,
      precio: double.parse(_precioCtrl.text.trim()),
      descripcion: _descripcionCtrl.text.trim(),
      caracteristicas: _caracteristicasCtrl.text
          .split(RegExp(r'[,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      imagenUrl:
          _imagenCtrl.text.trim().isEmpty ? null : _imagenCtrl.text.trim(),
      stock: int.parse(_stockCtrl.text.trim()),
    );
    Navigator.of(context).pop(producto);
  }

  @override
  Widget build(BuildContext context) {
    final teclado = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: teclado),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 22),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabecera limpia del modal
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.primario.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_box_outlined,
                      color: AppTheme.primario,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registrar componente',
                          style: TextStyle(
                            color: AppTheme.textoPrincipal,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Completa los datos técnicos del nuevo producto',
                          style: TextStyle(
                            color: AppTheme.textoSecundario,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppTheme.textoSecundario,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 16),

              // Nombre
              TextFormField(
                key: const Key('campoNombre'),
                controller: _nombreCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre del componente *',
                  prefixIcon: Icon(Icons.memory, size: 19),
                ),
                validator: (v) => _validarObligatorio(v, 'el nombre'),
              ),
              const SizedBox(height: 12),

              // Categoría
              DropdownButtonFormField<Categoria>(
                key: const Key('campoCategoria'),
                initialValue: _categoria,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Categoría *',
                  prefixIcon: Icon(Icons.category_outlined, size: 19),
                ),
                items: [
                  for (final c in Categoria.values)
                    DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          Icon(
                            c.icono,
                            size: 17,
                            color: AppTheme.textoSecundario,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              c.nombre,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.textoPrincipal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: (c) => setState(() => _categoria = c),
                validator: (c) => c == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 12),

              // Precio y stock
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      key: const Key('campoPrecio'),
                      controller: _precioCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Precio *',
                        hintText: '450.00',
                        prefixText: 'S/ ',
                        prefixIcon: Icon(Icons.payments_outlined, size: 19),
                      ),
                      validator: _validarPrecio,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      key: const Key('campoStock'),
                      controller: _stockCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Stock *',
                        prefixIcon: Icon(Icons.inventory_2_outlined, size: 19),
                      ),
                      validator: _validarStock,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Descripción
              TextFormField(
                key: const Key('campoDescripcion'),
                controller: _descripcionCtrl,
                minLines: 3,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descripción técnica *',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description_outlined, size: 19),
                ),
                validator: (v) => _validarObligatorio(v, 'la descripción'),
              ),
              const SizedBox(height: 12),

              // Características
              TextFormField(
                controller: _caracteristicasCtrl,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Características principales (opcional)',
                  hintText: 'Separadas por coma: 8 núcleos, 16 hilos, ...',
                  prefixIcon: Icon(Icons.checklist_rounded, size: 19),
                ),
              ),
              const SizedBox(height: 12),

              // Imagen
              TextFormField(
                controller: _imagenCtrl,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL de imagen (opcional)',
                  hintText: 'https://...',
                  prefixIcon: Icon(Icons.image_outlined, size: 19),
                ),
                validator: _validarUrl,
              ),
              const SizedBox(height: 20),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      key: const Key('btnGuardar'),
                      onPressed: _guardar,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: const Text('Guardar componente'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.acento,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
