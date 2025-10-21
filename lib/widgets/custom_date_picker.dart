import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Muestra un selector de fecha con tema oscuro y localización en español.
/// Solo permite fechas futuras (desde hoy en adelante).
Future<DateTime?> mostrarSelectorFecha({
  required BuildContext context,
  DateTime? fechaInicial,
  DateTime? fechaMinima,
  DateTime? fechaMaxima,
}) async {
  fechaInicial ??= DateTime.now();
  fechaMinima ??= DateTime.now();
  fechaMaxima ??= DateTime(2100);

  final DateTime? nuevaFecha = await showDatePicker(
    context: context,
    initialDate: fechaInicial,
    firstDate: fechaMinima,
    lastDate: fechaMaxima,
    locale: const Locale('es', 'ES'),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue, // Color principal del selector
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color(0xFF121212),
        ),
        child: child!,
      );
    },
  );

  return nuevaFecha;
}

/// Formatea una fecha en formato corto español (ej: 21/10/2025)
String formatearFecha(DateTime fecha) {
  return DateFormat('dd/MM/yyyy', 'es_ES').format(fecha);
}
