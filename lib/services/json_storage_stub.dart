/// Implementación en memoria (fallback para entornos web sin dart:io).
class JsonFileStorage {
  static String? _memoriaJson;

  static String get rutaArchivo => 'memoria://usuarios_sesion.json';

  static Future<String?> leerArchivo() async => _memoriaJson;

  static Future<String> escribirArchivo(String contenidoJson) async {
    _memoriaJson = contenidoJson;
    return rutaArchivo;
  }
}
