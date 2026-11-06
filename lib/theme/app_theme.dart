import 'package:flutter/material.dart';

/// Paleta y tema de la aplicación — Estilo Clean Tech E-commerce.
class AppTheme {
  AppTheme._();

  // Paleta de colores estricta Clean Tech E-commerce
  static const Color primario = Color(0xFF163D70); // Azul institucional
  static const Color acento = Color(0xFFE87524); // Naranja moderado
  static const Color fondoGeneral = Color(0xFFF4F5F7); // Fondo general
  static const Color fondoTarjeta = Color(0xFFFFFFFF); // Fondo de tarjetas
  static const Color textoPrincipal = Color(0xFF343A40); // Texto principal
  static const Color textoSecundario = Color(0xFF747B84); // Texto secundario
  static const Color borde = Color(0xFFE1E5EA); // Bordes
  static const Color disponible = Color(0xFF39734A); // Verde de disponibilidad
  static const Color agotado = Color(0xFF747B84); // Gris neutro para agotado
  static const Color error = Color(0xFFC53030); // Rojo sobrio para validaciones

  static ThemeData get claro {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: primario,
      brightness: Brightness.light,
    );

    final scheme = baseScheme.copyWith(
      primary: primario,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE8EEF5),
      onPrimaryContainer: primario,
      secondary: acento,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFFDF0E6),
      onSecondaryContainer: const Color(0xFF9A4409),
      surface: fondoTarjeta,
      onSurface: textoPrincipal,
      onSurfaceVariant: textoSecundario,
      outline: borde,
      outlineVariant: borde,
      error: error,
    );

    final baseText = Typography.material2021().black.apply(
          bodyColor: textoPrincipal,
          displayColor: textoPrincipal,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: fondoGeneral,
      textTheme: baseText.copyWith(
        headlineMedium: baseText.headlineMedium?.copyWith(
          color: textoPrincipal,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineSmall: baseText.headlineSmall?.copyWith(
          color: textoPrincipal,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          color: textoPrincipal,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          color: textoPrincipal,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        titleSmall: baseText.titleSmall?.copyWith(
          color: textoPrincipal,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(
          color: textoPrincipal,
          fontSize: 15,
        ),
        bodyMedium: baseText.bodyMedium?.copyWith(
          color: textoPrincipal,
          fontSize: 14,
        ),
        bodySmall: baseText.bodySmall?.copyWith(
          color: textoSecundario,
          fontSize: 12,
        ),
        labelMedium: baseText.labelMedium?.copyWith(
          color: textoSecundario,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: baseText.labelSmall?.copyWith(
          color: textoSecundario,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primario,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: fondoTarjeta,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borde, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borde,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: fondoTarjeta,
        selectedColor: primario,
        disabledColor: fondoGeneral,
        side: const BorderSide(color: borde),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(
          color: textoPrincipal,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fondoTarjeta,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        labelStyle: const TextStyle(color: textoSecundario, fontSize: 14),
        hintStyle: const TextStyle(color: textoSecundario, fontSize: 14),
        prefixIconColor: textoSecundario,
        suffixIconColor: textoSecundario,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borde, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primario, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: acento,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primario,
          side: const BorderSide(color: borde, width: 1),
          backgroundColor: fondoTarjeta,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: acento,
        foregroundColor: Colors.white,
        elevation: 2,
        focusElevation: 3,
        hoverElevation: 4,
        highlightElevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textoPrincipal,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: fondoTarjeta,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: fondoTarjeta,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
    );
  }
}
