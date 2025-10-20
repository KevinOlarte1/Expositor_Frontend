import 'package:flutter/material.dart';
import '../../models/pedido.dart';
import '../../service/api_service.dart';
import '../card/pedido_card.dart';

class PedidoList extends StatelessWidget {
  final int idCliente;
  final ApiService api = ApiService();

  PedidoList({super.key, required this.idCliente});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pedido>>(
      future: api.getPedidosByCliente(idCliente) as Future<List<Pedido>>?,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay pedidos"));
        }

        final pedidos = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            return PedidoCard(pedido: pedidos[index]);
          },
        );
      },
    );
  }
}
