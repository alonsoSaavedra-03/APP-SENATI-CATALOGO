import 'dart:convert';

import 'package:catalogo_senati/main.dart';
import 'package:catalogo_senati/services/auth_json_service.dart';
import 'package:catalogo_senati/utils/formato.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AuthJsonService.instance.reiniciarParaTests();
  });

  test('formatoSoles', () {
    expect(formatoSoles(450), 'S/ 450.00');
    expect(formatoSoles(1899.5), 'S/ 1,899.50');
    expect(formatoSoles(1234567.891), 'S/ 1,234,567.89');
  });

  testWidgets('Login, guardado en JSON, filtrar, buscar, ordenar y registrar',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const CatalogoSenatiApp());
    await tester.pumpAndSettle();

    // 1. Verifica que inicia en la pantalla de Login
    expect(find.text('Acceso al Catálogo SENATI'), findsOneWidget);

    // 2. Probar registro de un nuevo usuario y guardado en JSON antes de entrar
    await tester.tap(find.byKey(const Key('tabRegistro')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('campoNombreLogin')),
      'Carlos Alumno',
    );
    await tester.enterText(
      find.byKey(const Key('campoCorreoLogin')),
      'carlos@senati.pe',
    );
    await tester.enterText(
      find.byKey(const Key('campoPasswordLogin')),
      'senati123',
    );
    await tester.tap(find.byKey(const Key('btnSubmitLogin')));
    await tester.pumpAndSettle();

    // Verifica que el JSON contiene al usuario registrado y la sesión activa
    final jsonMap = jsonDecode(
      AuthJsonService.instance.obtenerJsonFormateado(),
    ) as Map<String, dynamic>;
    expect(jsonMap['sesionActiva']['correo'], 'carlos@senati.pe');
    expect(jsonMap['sesionActiva']['nombre'], 'Carlos Alumno');

    // 3. Ya dentro del catálogo
    expect(find.text('Catálogo SENATI'), findsOneWidget);
    expect(find.text('Procesador Intel Core i7-14700K'), findsOneWidget);

    // Filtro por categoría
    await tester.tap(find.widgetWithText(ChoiceChip, 'Periféricos'));
    await tester.pumpAndSettle();
    expect(find.text('Procesador Intel Core i7-14700K'), findsNothing);
    expect(find.text('Teclado mecánico USB'), findsOneWidget);

    // Volver a Todos y buscar
    await tester.tap(find.widgetWithText(ChoiceChip, 'Todos'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'ryzen');
    await tester.pumpAndSettle();
    expect(find.text('Procesador AMD Ryzen 7 7800X3D'), findsOneWidget);
    expect(find.text('SSD NVMe M.2 1 TB'), findsNothing);

    // Detalle
    await tester.tap(find.text('Procesador AMD Ryzen 7 7800X3D'));
    await tester.pumpAndSettle();
    expect(find.text('Ficha técnica'), findsOneWidget);
    expect(find.text('S/ 1,749.00'), findsOneWidget);
    expect(find.text('Stock disponible en almacén'), findsOneWidget);
    await tester.tap(find.text('Volver al catálogo'));
    await tester.pumpAndSettle();

    // Limpiar búsqueda
    await tester.enterText(find.byType(SearchBar), '');
    await tester.pumpAndSettle();

    // Ordenamiento por precio
    await tester.tap(find.byKey(const Key('selectorOrden')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Precio: menor a mayor').last);
    await tester.pumpAndSettle();
    expect(find.text('Mouse ergonómico gamer'), findsOneWidget);

    // Registro: validaciones
    await tester.tap(find.text('Agregar componente'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('btnGuardar')));
    await tester.pumpAndSettle();
    expect(find.text('Ingresa el nombre'), findsOneWidget);
    expect(find.text('Selecciona una categoría'), findsOneWidget);
    expect(find.text('Ingresa el precio'), findsOneWidget);

    // Registro: datos válidos
    await tester.enterText(find.byKey(const Key('campoNombre')), 'Webcam HD');
    await tester.tap(find.byKey(const Key('campoCategoria')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Periféricos').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('campoPrecio')), '120.50');
    await tester.enterText(
      find.byKey(const Key('campoDescripcion')),
      'Cámara 1080p USB',
    );
    await tester.tap(find.byKey(const Key('btnGuardar')));
    await tester.pumpAndSettle();

    expect(find.text('Webcam HD'), findsOneWidget);
    expect(find.text('S/ 120.50'), findsOneWidget);
    expect(find.textContaining('registrado correctamente'), findsOneWidget);
  });

  testWidgets('Diseño en pantalla de celular con login demo sin desbordes',
      (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const CatalogoSenatiApp());
    await tester.pumpAndSettle();

    // Autocompletar con cuenta demo e ingresar
    await tester.ensureVisible(find.byKey(const Key('btnAutocompletarDemo')));
    await tester.tap(find.byKey(const Key('btnAutocompletarDemo')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('btnSubmitLogin')));
    await tester.tap(find.byKey(const Key('btnSubmitLogin')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Procesador Intel Core i7-14700K'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Procesador Intel Core i7-14700K'));
    await tester.pumpAndSettle();
    expect(find.text('Ficha técnica'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('fabAgregar')));
    await tester.pumpAndSettle();
    expect(find.text('Registrar componente'), findsOneWidget);
  });
}
