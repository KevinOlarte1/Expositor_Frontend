import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/api_service.dart';
import '../models/vendedor.dart';
import '../models/cliente.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/stats_card.dart';
import '../widgets/button/custom_action_button.dart';
import '../widgets/cliente_card.dart';
import '../utils/session_manager.dart'; // ✅ Import para la sesión global
import 'stats_detail_page.dart';

class DashboardPage extends StatelessWidget {
  final ApiService api = ApiService();
  static const int idVendedor =
      1; // 🔹 ID por defecto (puedes cambiarlo si usas login)

  @override
  Widget build(BuildContext context) {
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

            // ✅ Guardamos el vendedor globalmente al cargar el dashboard
            SessionManager.setVendedor(
              id: vendedor.id,
              nombre: vendedor.nombre,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 AppBar con nombre del vendedor
                CustomAppBar(
                  name: vendedor.nombre,
                  avatarUrl: "https://cdn.pfps.gg/pfps/2903-default-blue.png",
                ),

                // 🔹 Tarjeta de estadísticas
                StatsCard(
                  total: 276,
                  ventasAbiertas: 374,
                  ventasCerradas: 98,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatsDetailPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // 🔹 Botón de acción
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomActionButton(
                    text: "Realizar venta",
                    icon: Icons.shopping_cart_checkout,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Acción: Realizar venta 🚀"),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Header de lista de clientes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Clientes",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Acción para añadir cliente
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Acción: Añadir cliente ➕"),
                            ),
                          );
                        },
                        child: Text(
                          "+ Añadir cliente",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // 🔹 Lista de clientes
                Expanded(
                  child: FutureBuilder<List<Cliente>>(
                    future: api.getClientesByVendedor(idVendedor),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No hay clientes"));
                      }

                      final clientes = snapshot.data!;

                      return ListView.builder(
                        itemCount: clientes.length,
                        itemBuilder: (context, index) {
                          return ClienteCard(cliente: clientes[index]);
                        },
                      );
                    },
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
