import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsCard extends StatelessWidget {
  final int total;
  final int ventasAbiertas;
  final int ventasCerradas;
  final VoidCallback? onTap; // 🔹 nuevo parámetro

  const StatsCard({
    Key? key,
    required this.total,
    required this.ventasAbiertas,
    required this.ventasCerradas,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateFormat("MMM dd, yyyy").format(DateTime.now());

    return GestureDetector(
      onTap: onTap, // 🔹 ejecuta la acción al tocar
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Título y fecha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Hoy",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  today,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Métricas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(total, "Total"),
                Container(height: 40, width: 1, color: Colors.white24),
                _buildStat(ventasAbiertas, "Ventas Abiertas"),
                Container(height: 40, width: 1, color: Colors.white24),
                _buildStat(ventasCerradas, "Ventas Cerradas"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
