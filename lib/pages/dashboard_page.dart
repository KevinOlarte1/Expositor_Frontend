import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/api_service.dart';
import '../models/vendedor.dart';
import '../models/cliente.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/stats_card.dart';
import '../widgets/button/custom_action_button.dart';
import '../widgets/cliente_card.dart';
import '../utils/session_manager.dart';

/// Página principal del Dashboard.
/// Muestra el vendedor, estadísticas y la lista de clientes.
class DashboardPage extends StatelessWidget {
  final ApiService api = ApiService();

  final int idVendedor = SessionManager.getIdVendedro();

  DashboardPage({super.key}); // 🔸 sin const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FutureBuilder<Vendedor>(
          future: api.getVendedor(idVendedor),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("No se encontró el vendedor"));
            }

            final vendedor = snapshot.data!;

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Ir a detalle de estadísticas 📊"),
                      ),
                    );
                  },
                ),

                SizedBox(height: 16),

                // 🔹 Botón de acción principal
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomActionButton(
                    text: "Realizar venta",
                    icon: Icons.shopping_cart_checkout,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Acción: Realizar venta 🚀")),
                      );
                    },
                  ),
                ),

                SizedBox(height: 16),

                // 🔹 Header de lista de clientes
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Clientes",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Acción: Añadir cliente ➕")),
                          );
                        },
                        child: Text(
                          "+ Añadir cliente",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
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

                SizedBox(height: 8),

                // 🔹 Lista de clientes modularizada
                Expanded(child: ClienteList(idVendedor: idVendedor)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Widget modularizado para la lista de clientes.
/// Encapsula la carga y renderización de la lista desde la API.
class ClienteList extends StatelessWidget {
  final int idVendedor;
  final ApiService api = ApiService();

  ClienteList({super.key, required this.idVendedor}); // 🔸 sin const

  @override
  Widget build(BuildContext context) {
    final Future<List<Cliente>>? clientesFuture = api.getClientesByVendedor(
      idVendedor,
    );

    return FutureBuilder<List<Cliente>>(
      future: clientesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No hay clientes"));
        }

        final clientes = snapshot.data!;
        return ListView.builder(
          itemCount: clientes.length,
          itemBuilder: (context, index) {
            return ClientCard(cliente: clientes[index]);
          },
        );
      },
    );
  }
}
