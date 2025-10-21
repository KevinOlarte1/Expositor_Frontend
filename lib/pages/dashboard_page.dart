import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_app/pages/add_cliente_page.dart';
import '../service/api_service.dart';
import '../models/vendedor.dart';
import '../models/cliente.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/stats_card.dart';
import '../widgets/button/custom_action_button.dart';
import '../widgets/card/cliente_card.dart';
import '../pages/realizar_venta_page.dart';
import '../utils/session_manager.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService api = ApiService();
  final int idVendedor = SessionManager.getIdVendedro();

  // 🔁 Key para acceder al estado de ClienteList
  final GlobalKey<_ClienteListState> clienteListKey = GlobalKey();

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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomAppBar(
                  name: vendedor.nombre,
                  avatarUrl: "https://cdn.pfps.gg/pfps/2903-default-blue.png",
                ),

                StatsCard(
                  total: 276,
                  ventasAbiertas: 374,
                  ventasCerradas: 98,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Ir a detalle de estadísticas 📊"),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomActionButton(
                    text: "Realizar venta",
                    icon: Icons.shopping_cart_checkout,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RealizarVentaPage(idVendedor: idVendedor),
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
                      Row(
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
                          const SizedBox(width: 6),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.blue),
                            tooltip: "Actualizar lista",
                            onPressed: () {
                              // 🔹 Llamamos al método del ClienteList
                              clienteListKey.currentState?.recargarClientes();
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          // 🔹 Navegamos y al volver refrescamos la lista
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddClientePage(),
                            ),
                          );
                          clienteListKey.currentState?.recargarClientes();
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

                // 🔹 Le pasamos la key para poder refrescar desde fuera
                Expanded(
                  child: ClienteList(
                    key: clienteListKey,
                    idVendedor: idVendedor,
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

//
// 🔹 ClienteList ahora es un StatefulWidget para poder recargar datos
//
class ClienteList extends StatefulWidget {
  final int idVendedor;

  const ClienteList({super.key, required this.idVendedor});

  @override
  State<ClienteList> createState() => _ClienteListState();
}

class _ClienteListState extends State<ClienteList> {
  final ApiService api = ApiService();
  late Future<List<Cliente>> clientesFuture;

  @override
  void initState() {
    super.initState();
    clientesFuture = api.getClientesByVendedor(widget.idVendedor);
  }

  // 🔁 Método público para volver a cargar los clientes
  void recargarClientes() {
    setState(() {
      clientesFuture = api.getClientesByVendedor(widget.idVendedor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cliente>>(
      future: clientesFuture,
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
            return ClientCard(cliente: clientes[index]);
          },
        );
      },
    );
  }
}
