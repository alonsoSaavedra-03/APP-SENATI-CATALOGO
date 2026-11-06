/// Formatea un monto en soles. Ejemplo: 1899.5 -> "S/ 1,899.50".
String formatoSoles(double monto) {
  final partes = monto.toStringAsFixed(2).split('.');
  final entero = partes[0];
  final buffer = StringBuffer();
  for (var i = 0; i < entero.length; i++) {
    if (i > 0 && (entero.length - i) % 3 == 0) buffer.write(',');
    buffer.write(entero[i]);
  }
  return 'S/ $buffer.${partes[1]}';
}
