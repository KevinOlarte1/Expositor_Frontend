import 'package:flutter/material.dart';
import '../models/cliente.dart';

class ClientCard extends StatelessWidget {
  final Cliente cliente;

  const ClientCard({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Color(0xFF2b2b2b),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            cliente.nombre[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          cliente.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          "COD: ${cliente.id}",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        // 🔹 En vez de la flecha, mostramos pedidos
        trailing: Text(
          "pedidos: ${cliente.idPedidos.length}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Cliente: ${cliente.nombre}")));
        },
      ),
    );
  }
}
