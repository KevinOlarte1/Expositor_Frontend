import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cliente.dart';
import '../models/vendedor.dart';
import '../service/api_service.dart';
import '../utils/session_manager.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/charts/monthly_sales_chart.dart';
import '../pages/pedido_detail_page.dart';
import '../widgets/card/pedido_card.dart';
import '../models/pedido.dart';

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

class PedidoList extends StatefulWidget {
  final int idCliente;

  const PedidoList({super.key, required this.idCliente});

  @override
  State<PedidoList> createState() => _PedidoListState();
}

class _PedidoListState extends State<PedidoList> {
  final ApiService api = ApiService();
  late Future<List<Pedido>> pedidosFuture;

  @override
  void initState() {
    super.initState();
    pedidosFuture = _cargarPedidos();
  }

  Future<List<Pedido>> _cargarPedidos() async {
    return await api.getPedidosByCliente(widget.idCliente);
  }

  Future<void> _refrescarPedidos() async {
    final nuevosPedidos = await api.getPedidosByCliente(widget.idCliente);
    setState(() {
      pedidosFuture = Future.value(
        nuevosPedidos,
      ); // 🔹 fuerza rebuild inmediato
    });
  }

  /// 🔹 Abrir la página de detalle del pedido
  Future<void> _abrirPedidoDetalle(Pedido pedido) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PedidoDetailPage(pedido: pedido)),
    );

    if (result == true) {
      await _refrescarPedidos(); // 🔹 fuerza recarga real
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pedido>>(
      future: pedidosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final pedidos = snapshot.data ?? [];

        if (pedidos.isEmpty) {
          return const Center(child: Text("No hay pedidos registrados."));
        }

        return RefreshIndicator(
          onRefresh: _refrescarPedidos,
          child: ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];

              return GestureDetector(
                onTap: () => _abrirPedidoDetalle(pedido),
                child: PedidoCard(pedido: pedido),
              );
            },
          ),
        );
      },
    );
  }
}
