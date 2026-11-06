import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/usuario.dart';
import 'json_storage_stub.dart'
    if (dart.library.io) 'json_storage_io.dart';

/// Resultado de una operación de login o registro.
class ResultadoAuth {
  final bool exito;
  final String mensaje;
  final Usuario? usuario;
  final String? rutaJson;

  const ResultadoAuth({
    required this.exito,
    required this.mensaje,
    this.usuario,
    this.rutaJson,
  });
}

/// Servicio encargado de gestionar el Login/Registro y persistir los datos
/// en formato JSON (`usuarios_sesion.json`) antes de ingresar al catálogo.
class AuthJsonService {
  AuthJsonService._();

  static final AuthJsonService instance = AuthJsonService._();

  static const Usuario usuarioDemo = Usuario(
    id: 'usr-senati-01',
    nombre: 'Administrador SENATI',
    correo: 'admin@senati.pe',
    password: '123456',
    fechaRegistro: '2026-11-06T08:00:00.000',
  );

  final List<Usuario> _usuarios = [usuarioDemo];
  final List<Map<String, dynamic>> _historialIngresos = [];
  Usuario? _usuarioActual;
  String _actualizadoEn = DateTime.now().toIso8601String();
  bool _inicializado = false;

  Usuario? get usuarioActual => _usuarioActual;
  List<Usuario> get usuarios => List.unmodifiable(_usuarios);
  String get rutaArchivoJson => JsonFileStorage.rutaArchivo;

  /// Carga los usuarios desde el archivo JSON local o desde el asset semilla `assets/data/usuarios.json`.
  Future<void> inicializar() async {
    if (_inicializado) return;
    _inicializado = true;

    String? contenido = await JsonFileStorage.leerArchivo();
    if (contenido == null || contenido.trim().isEmpty) {
      try {
        contenido = await rootBundle.loadString('assets/data/usuarios.json');
      } catch (_) {
        contenido = null;
      }
    }

    if (contenido != null && contenido.trim().isNotEmpty) {
      _cargarDesdeJsonString(contenido);
    }

    _asegurarUsuarioDemo();
    await guardarEnJson();
  }

  void _cargarDesdeJsonString(String rawJson) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) return;

      final listaUsuarios = decoded['usuarios'];
      if (listaUsuarios is List) {
        _usuarios
          ..clear()
          ..addAll(
            listaUsuarios
                .whereType<Map>()
                .map((e) => Usuario.fromJson(Map<String, dynamic>.from(e))),
          );
      }

      final historial = decoded['historialIngresos'];
      if (historial is List) {
        _historialIngresos
          ..clear()
          ..addAll(
            historial
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e)),
          );
      }

      final sesion = decoded['sesionActiva'];
      if (sesion is Map) {
        final correoSesion = (sesion['correo'] ?? '').toString().toLowerCase();
        for (final u in _usuarios) {
          if (u.correo.toLowerCase() == correoSesion) {
            _usuarioActual = u;
            break;
          }
        }
      }
    } catch (_) {
      // Si el JSON está corrupto, se restaura con el usuario demo por defecto.
    }
  }

  void _asegurarUsuarioDemo() {
    final existeDemo = _usuarios.any(
      (u) => u.correo.toLowerCase() == usuarioDemo.correo.toLowerCase(),
    );
    if (!existeDemo) {
      _usuarios.insert(0, usuarioDemo);
    }
  }

  /// Construye el mapa completo que se serializa en el archivo JSON.
  Map<String, dynamic> construirEstructuraJson() {
    return {
      'actualizadoEn': _actualizadoEn,
      'sesionActiva': _usuarioActual?.toSesionJson(_actualizadoEn),
      'historialIngresos': _historialIngresos,
      'usuarios': _usuarios.map((u) => u.toJson()).toList(),
    };
  }

  /// Devuelve el JSON formateado con indentación de 2 espacios.
  String obtenerJsonFormateado() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(construirEstructuraJson());
  }

  /// Serializa y escribe el estado actual en `usuarios_sesion.json`.
  Future<String> guardarEnJson() async {
    _actualizadoEn = DateTime.now().toIso8601String();
    final jsonString = obtenerJsonFormateado();
    return JsonFileStorage.escribirArchivo(jsonString);
  }

  /// Valida credenciales, registra el ingreso y guarda en JSON antes de entrar al catálogo.
  Future<ResultadoAuth> iniciarSesion({
    required String correoOUsuario,
    required String password,
  }) async {
    await inicializar();

    final entrada = correoOUsuario.trim().toLowerCase();
    final clave = password.trim();

    Usuario? encontrado;
    for (final u in _usuarios) {
      final correoLower = u.correo.toLowerCase();
      final usuarioPrefijo = correoLower.split('@').first;
      if ((correoLower == entrada || usuarioPrefijo == entrada) &&
          u.password == clave) {
        encontrado = u;
        break;
      }
    }

    if (encontrado == null) {
      return const ResultadoAuth(
        exito: false,
        mensaje: 'Credenciales incorrectas. Verifica tu correo/usuario y contraseña.',
      );
    }

    final ahora = DateTime.now().toIso8601String();
    _usuarioActual = encontrado;
    _actualizadoEn = ahora;
    _historialIngresos.insert(0, {
      'idUsuario': encontrado.id,
      'nombre': encontrado.nombre,
      'correo': encontrado.correo,
      'fechaIngreso': ahora,
      'metodo': 'login',
    });

    final ruta = await guardarEnJson();

    return ResultadoAuth(
      exito: true,
      mensaje: 'Sesión guardada en JSON · Bienvenido(a), ${encontrado.nombre}',
      usuario: encontrado,
      rutaJson: ruta,
    );
  }

  /// Registra un nuevo usuario, lo activa en sesión y guarda todo en JSON antes de entrar.
  Future<ResultadoAuth> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    await inicializar();

    final correoLimpio = correo.trim();
    final nombreLimpio = nombre.trim();
    final claveLimpia = password.trim();

    final yaExiste = _usuarios.any(
      (u) => u.correo.toLowerCase() == correoLimpio.toLowerCase(),
    );

    if (yaExiste) {
      return const ResultadoAuth(
        exito: false,
        mensaje: 'Ya existe un usuario registrado con ese correo o usuario.',
      );
    }

    final ahora = DateTime.now().toIso8601String();
    final nuevo = Usuario(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      nombre: nombreLimpio,
      correo: correoLimpio,
      password: claveLimpia,
      fechaRegistro: ahora,
    );

    _usuarios.add(nuevo);
    _usuarioActual = nuevo;
    _actualizadoEn = ahora;
    _historialIngresos.insert(0, {
      'idUsuario': nuevo.id,
      'nombre': nuevo.nombre,
      'correo': nuevo.correo,
      'fechaIngreso': ahora,
      'metodo': 'registro',
    });

    final ruta = await guardarEnJson();

    return ResultadoAuth(
      exito: true,
      mensaje: 'Usuario guardado en JSON · Bienvenido(a), ${nuevo.nombre}',
      usuario: nuevo,
      rutaJson: ruta,
    );
  }

  /// Cierra la sesión activa y actualiza el archivo JSON.
  Future<void> cerrarSesion() async {
    _usuarioActual = null;
    await guardarEnJson();
  }

  /// Reinicia el estado en pruebas unitarias/widgets.
  void reiniciarParaTests() {
    _usuarios
      ..clear()
      ..add(usuarioDemo);
    _historialIngresos.clear();
    _usuarioActual = null;
    _inicializado = true;
  }
}
