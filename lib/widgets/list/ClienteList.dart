// widgets/cliente_list.dart
import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../service/api_service.dart';
import '../cliente_card.dart';

class ClienteList extends StatelessWidget {
  final int idVendedor;
  final ApiService api = ApiService();

  ClienteList({super.key, required this.idVendedor});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cliente>>(
      future: api.getClientesByVendedor(idVendedor) as Future<List<Cliente>>?,
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
