import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cliente.dart';
import '../models/vendedor.dart';
import '../service/api_service.dart';
import '../utils/session_manager.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/charts/monthly_sales_chart.dart';
import '../widgets/list/pedido_list.dart';

class ClienteDetailPage extends StatelessWidget {
  final Cliente cliente;
  final ApiService api = ApiService();

  ClienteDetailPage({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    final int idVendedor = SessionManager.getIdVendedro(); // ✅ mover aquí

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FutureBuilder<Vendedor>(
          future: api.getVendedor(idVendedor),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No se encontró el vendedor"));
            }

            final vendedor = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomAppBar(
                  name: vendedor.nombre,
                  avatarUrl: "https://cdn.pfps.gg/pfps/2903-default-blue.png",
                ),
                const SizedBox(height: 24),

                // 🔹 Info del cliente
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue,
                        child: Text(
                          cliente.nombre[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cliente.nombre,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            cliente.email ?? "sin correo",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MonthlySalesChart(clienteId: cliente.id),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PedidoList(idCliente: cliente.id), // ✅ correcto
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
