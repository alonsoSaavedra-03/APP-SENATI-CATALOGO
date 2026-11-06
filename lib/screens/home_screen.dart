import 'package:flutter/material.dart';

import '../data/productos_iniciales.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../routes/app_routes.dart';
import '../services/auth_json_service.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_catalogo.dart';
import '../widgets/buscador_productos.dart';
import '../widgets/catalogo_toolbar.dart';
import '../widgets/categoria_chips.dart';
import '../widgets/producto_card.dart';
import '../widgets/registro_producto_sheet.dart';
import '../widgets/visor_json_dialog.dart';

/// Pantalla principal: catálogo Clean Tech E-commerce con buscador, filtros,
/// ordenamiento y cuadrícula adaptable.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Producto> _productos = [...productosIniciales];
  final _busquedaCtrl = TextEditingController();

  String _busqueda = '';
  Categoria? _categoria; // null = Todos
  OrdenCatalogo _orden = OrdenCatalogo.recientes;

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  /// Productos que cumplen la búsqueda, categoría y orden seleccionado.
  List<Producto> get _filtrados {
    final q = _busqueda.trim().toLowerCase();
    final resultado = _productos.where((p) {
      final coincideCategoria = _categoria == null || p.categoria == _categoria;
      final coincideNombre = q.isEmpty || p.nombre.toLowerCase().contains(q);
      return coincideCategoria && coincideNombre;
    }).toList();

    switch (_orden) {
      case OrdenCatalogo.recientes:
        break;
      case OrdenCatalogo.nombreAsc:
        resultado.sort(
          (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
        );
      case OrdenCatalogo.precioMenor:
        resultado.sort((a, b) => a.precio.compareTo(b.precio));
      case OrdenCatalogo.precioMayor:
        resultado.sort((a, b) => b.precio.compareTo(a.precio));
    }
    return resultado;
  }

  void _seleccionarCategoria(Categoria? c) {
    setState(() => _categoria = c);
    final total = _filtrados.length;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Filtro: ${c?.nombre ?? 'Todos'} · $total producto${total == 1 ? '' : 's'}',
          ),
          duration: const Duration(milliseconds: 1200),
        ),
      );
  }

  Future<void> _registrar() async {
    final nuevo = await RegistroProductoSheet.mostrar(context);
    if (nuevo == null || !mounted) return;

    setState(() => _productos.insert(0, nuevo));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text('«${nuevo.nombre}» registrado correctamente'),
              ),
            ],
          ),
          backgroundColor: AppTheme.disponible,
        ),
      );
  }

  void _abrirDetalle(Producto p) {
    Navigator.pushNamed(context, AppRoutes.detalle, arguments: p);
  }

  Future<void> _cerrarSesion() async {
    await AuthJsonService.instance.cerrarSesion();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  /// Calcula el número de columnas según el ancho disponible:
  /// Móviles: 2 · Tablets: 3 · Escritorio: 4 o 5.
  int _calcularColumnas(double anchoDisponible) {
    if (anchoDisponible >= 1200) return 5;
    if (anchoDisponible >= 900) return 4;
    if (anchoDisponible >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final productos = _filtrados;
    final anchoPantalla = MediaQuery.sizeOf(context).width;
    final esEscritorio = anchoPantalla >= 860;
    final esMovil = anchoPantalla < 600;

    // Contenedor centrado con ancho máximo de tienda profesional (1320 px).
    const maxAnchoContenido = 1320.0;
    final padHorizontal = anchoPantalla > maxAnchoContenido
        ? (anchoPantalla - maxAnchoContenido) / 2 + 20
        : (esMovil ? 14.0 : 20.0);

    final anchoUtil = anchoPantalla - (padHorizontal * 2);
    final columnas = _calcularColumnas(anchoUtil);

    return Scaffold(
      appBar: _EncabezadoCatalogo(
        esEscritorio: esEscritorio,
        padHorizontal: padHorizontal,
        busquedaCtrl: _busquedaCtrl,
        onBusquedaChanged: (v) => setState(() => _busqueda = v),
        onRegistrar: _registrar,
        onVerJson: () => VisorJsonDialog.mostrar(context),
        onCerrarSesion: _cerrarSesion,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(padHorizontal, 0, padHorizontal, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BannerCatalogo(totalProductos: _productos.length),
            CategoriaChips(
              seleccionada: _categoria,
              onSeleccionar: _seleccionarCategoria,
            ),
            const SizedBox(height: 16),
            CatalogoToolbar(
              totalResultados: productos.length,
              ordenActual: _orden,
              onOrdenChanged: (nuevo) => setState(() => _orden = nuevo),
            ),
            const SizedBox(height: 12),
            if (productos.isEmpty)
              const _SinResultados()
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnas,
                  mainAxisExtent: esMovil ? 276 : 292,
                  crossAxisSpacing: esMovil ? 10 : 14,
                  mainAxisSpacing: esMovil ? 10 : 14,
                ),
                itemCount: productos.length,
                itemBuilder: (context, i) => ProductoCard(
                  producto: productos[i],
                  onTap: () => _abrirDetalle(productos[i]),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: esMovil
          ? FloatingActionButton(
              key: const Key('fabAgregar'),
              tooltip: 'Agregar componente',
              onPressed: _registrar,
              child: const Icon(Icons.add),
            )
          : FloatingActionButton.extended(
              key: const Key('fabAgregar'),
              onPressed: _registrar,
              icon: const Icon(Icons.add),
              label: const Text('Agregar componente'),
            ),
    );
  }
}

/// Encabezado institucional adaptable (una fila en escritorio, dos en móvil).
class _EncabezadoCatalogo extends StatelessWidget
    implements PreferredSizeWidget {
  final bool esEscritorio;
  final double padHorizontal;
  final TextEditingController busquedaCtrl;
  final ValueChanged<String> onBusquedaChanged;
  final VoidCallback onRegistrar;
  final VoidCallback onVerJson;
  final VoidCallback onCerrarSesion;

  const _EncabezadoCatalogo({
    required this.esEscritorio,
    required this.padHorizontal,
    required this.busquedaCtrl,
    required this.onBusquedaChanged,
    required this.onRegistrar,
    required this.onVerJson,
    required this.onCerrarSesion,
  });

  @override
  Size get preferredSize => Size.fromHeight(esEscritorio ? 68 : 116);

  @override
  Widget build(BuildContext context) {
    final usuario = AuthJsonService.instance.usuarioActual;

    return Material(
      color: AppTheme.primario,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padHorizontal,
            vertical: esEscritorio ? 12 : 10,
          ),
          child: esEscritorio
              ? Row(
                  children: [
                    const _Logo(),
                    const SizedBox(width: 28),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: BuscadorProductos(
                          controller: busquedaCtrl,
                          onChanged: onBusquedaChanged,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (usuario != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 140),
                              child: Text(
                                usuario.nombre,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    IconButton(
                      key: const Key('btnVerJsonHome'),
                      tooltip: 'Ver archivo JSON de sesión',
                      onPressed: onVerJson,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.10),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.data_object_rounded, size: 20),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Registrar componente',
                      onPressed: onRegistrar,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.10),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.add_box_outlined, size: 20),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      key: const Key('btnCerrarSesion'),
                      tooltip: 'Cerrar sesión',
                      onPressed: onCerrarSesion,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.10),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 20),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: _Logo()),
                        IconButton(
                          key: const Key('btnVerJsonHome'),
                          tooltip: 'Ver archivo JSON de sesión',
                          visualDensity: VisualDensity.compact,
                          onPressed: onVerJson,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.10),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.data_object_rounded, size: 19),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          tooltip: 'Registrar componente',
                          visualDensity: VisualDensity.compact,
                          onPressed: onRegistrar,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.10),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add_box_outlined, size: 19),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          key: const Key('btnCerrarSesion'),
                          tooltip: 'Cerrar sesión',
                          visualDensity: VisualDensity.compact,
                          onPressed: onCerrarSesion,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.10),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.logout_rounded, size: 19),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    BuscadorProductos(
                      controller: busquedaCtrl,
                      onChanged: onBusquedaChanged,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _BolsaSenatiLogo(size: 38),
        const SizedBox(width: 10),
        const Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Catálogo SENATI',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17.5,
                        letterSpacing: 0.2,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                'Componentes de hardware y periféricos',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFFD0DAE8),
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Isotipo vectorial estilo Shopify: bolsa de compras en perspectiva con la «S» de SENATI.
class _BolsaSenatiLogo extends StatelessWidget {
  final double size;

  const _BolsaSenatiLogo({this.size = 38});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BolsaSenatiPainter(),
        child: const Align(
          alignment: Alignment(-0.08, 0.28),
          child: Text(
            'S',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _BolsaSenatiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Asa trasera (más oscura para dar profundidad estilo Shopify)
    final asaTraseraPaint = Paint()
      ..color = const Color(0xFFC25B12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round;

    final asaTraseraPath = Path()
      ..moveTo(w * 0.38, h * 0.27)
      ..cubicTo(
        w * 0.40,
        h * 0.06,
        w * 0.68,
        h * 0.06,
        w * 0.68,
        h * 0.28,
      );
    canvas.drawPath(asaTraseraPath, asaTraseraPaint);

    // Fuelle lateral derecho de la bolsa (tono naranja oscuro)
    final lateralPaint = Paint()
      ..color = const Color(0xFFC25B12)
      ..style = PaintingStyle.fill;

    final lateralPath = Path()
      ..moveTo(w * 0.76, h * 0.26)
      ..lineTo(w * 0.90, h * 0.31)
      ..lineTo(w * 0.85, h * 0.90)
      ..lineTo(w * 0.72, h * 0.93)
      ..close();
    canvas.drawPath(lateralPath, lateralPaint);

    // Cara frontal principal de la bolsa (trapecio estilizado en naranja #E87524)
    final frentePaint = Paint()
      ..color = AppTheme.acento
      ..style = PaintingStyle.fill;

    final frenteRRectPath = Path()
      ..moveTo(w * 0.17, h * 0.25)
      ..lineTo(w * 0.77, h * 0.25)
      ..lineTo(w * 0.73, h * 0.93)
      ..lineTo(w * 0.11, h * 0.89)
      ..close();
    canvas.drawPath(frenteRRectPath, frentePaint);

    // Pliegue superior sutil de la bolsa
    final plieguePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    final plieguePath = Path()
      ..moveTo(w * 0.17, h * 0.25)
      ..lineTo(w * 0.77, h * 0.25)
      ..lineTo(w * 0.76, h * 0.31)
      ..lineTo(w * 0.16, h * 0.31)
      ..close();
    canvas.drawPath(plieguePath, plieguePaint);

    // Asa frontal blanca/clara arqueada
    final asaFrontalPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round;

    final asaFrontalPath = Path()
      ..moveTo(w * 0.31, h * 0.29)
      ..cubicTo(
        w * 0.31,
        h * 0.08,
        w * 0.59,
        h * 0.08,
        w * 0.59,
        h * 0.29,
      );
    canvas.drawPath(asaFrontalPath, asaFrontalPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SinResultados extends StatelessWidget {
  const _SinResultados();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: AppTheme.fondoTarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borde),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppTheme.textoSecundario,
          ),
          SizedBox(height: 10),
          Text(
            'No se encontraron componentes',
            style: TextStyle(
              color: AppTheme.textoPrincipal,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Prueba con otro término de búsqueda o selecciona otra categoría.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textoSecundario,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
