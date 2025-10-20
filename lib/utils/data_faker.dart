import 'dart:math';
import 'package:flutter/material.dart';

/// 🔹 DataFaker
/// Genera datos simulados para pruebas, imitando el formato de tu API real.
/// Ejemplo de salida:
/// { "01/10/2025": 200.0, "02/10/2025": 320.5, ... }
class DataFaker {
  /// Genera datos aleatorios de ventas ($) por día del mes actual.
  static Future<Map<String, double>> generateMonthlySales() async {
    /* await Future.delayed(
      const Duration(milliseconds: 300),
    );*/ // simula delay de red
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final random = Random();

    final Map<String, double> data = {};
    for (int i = 1; i <= daysInMonth; i++) {
      final day = i.toString().padLeft(2, '0');
      final month = now.month.toString().padLeft(2, '0');
      final year = now.year.toString();
      data["$day/$month/$year"] = 100 + random.nextDouble() * 400; // $100–$500
    }
    return data;
  }
}
