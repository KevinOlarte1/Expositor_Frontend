import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/data_faker.dart';

class MonthlySalesChart extends StatelessWidget {
  final int clienteId; // 🔹 añadimos este campo

  const MonthlySalesChart({super.key, required this.clienteId}); // 🔹 requerido

  // Convierte "dd/MM/yyyy" → "yyyy-MM-dd"
  String _toIsoDate(String dateStr) {
    final parts = dateStr.split('/');
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }

  // Carga datos falsos simulando el endpoint (listos para futuro API real)
  Future<List<FlSpot>> _loadVentasMensuales() async {
    // En el futuro puedes usar clienteId aquí:
    // final ventas = await api.getVentasMensualesCliente(clienteId);
    final ventas = await DataFaker.generateMonthlySales();

    final sortedKeys = ventas.keys.toList()
      ..sort((a, b) {
        final da = DateTime.parse(_toIsoDate(a));
        final db = DateTime.parse(_toIsoDate(b));
        return da.compareTo(db);
      });

    return sortedKeys.map((key) {
      final date = DateTime.parse(_toIsoDate(key));
      final day = date.day.toDouble();
      final value = ventas[key] ?? 0;
      return FlSpot(day, value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<FlSpot>>(
          future: _loadVentasMensuales(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Sin datos de ventas"));
            }

            final salesData = snapshot.data!;

            return LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) => Text(
                        "\$${value.toInt()}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: salesData,
                    isCurved: true,
                    color: Colors.greenAccent[400],
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.greenAccent.withOpacity(0.3),
                          Colors.greenAccent.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
