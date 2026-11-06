import 'dart:io';

/// Almacenamiento físico de archivo JSON en dispositivo/escritorio mediante dart:io.
class JsonFileStorage {
  static const String _nombreArchivo = 'usuarios_sesion.json';
  static String _rutaActual = _nombreArchivo;

  static String get rutaArchivo => _rutaActual;

  static File _resolverArchivoSync() {
    // Intenta usar el directorio de trabajo actual (ideal en escritorio/desarrollo)
    try {
      final archivoLocal = File(
        '${Directory.current.path}${Platform.pathSeparator}$_nombreArchivo',
      );
      if (archivoLocal.existsSync()) {
        _rutaActual = archivoLocal.path;
        return archivoLocal;
      }
      // Verifica si el directorio actual permite escritura
      archivoLocal.writeAsStringSync('', mode: FileMode.append);
      _rutaActual = archivoLocal.path;
      return archivoLocal;
    } catch (_) {
      // En Android/iOS el directorio raíz es de solo lectura; usa el directorio temporal del sistema
      final archivoTemp = File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}$_nombreArchivo',
      );
      _rutaActual = archivoTemp.path;
      return archivoTemp;
    }
  }

  static Future<String?> leerArchivo() async {
    try {
      final file = _resolverArchivoSync();
      if (!file.existsSync()) return null;
      final contenido = file.readAsStringSync();
      if (contenido.trim().isEmpty) return null;
      return contenido;
    } catch (_) {
      return null;
    }
  }

  static Future<String> escribirArchivo(String contenidoJson) async {
    try {
      final file = _resolverArchivoSync();
      file.writeAsStringSync(contenidoJson, flush: true);
      _rutaActual = file.path;
      return file.path;
    } catch (_) {
      return _rutaActual;
    }
  }
}
