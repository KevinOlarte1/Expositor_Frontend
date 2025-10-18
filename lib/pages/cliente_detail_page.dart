import 'package:flutter/material.dart';
import '../widgets/app_bar/CustomBlackAppBar.dart';
import '../models/cliente.dart';
import '../utils/session_manager.dart'; // 👈 Importa el session manager

class ClienteDetailPage extends StatelessWidget {
  final Cliente cliente;

  const ClienteDetailPage({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vendedorNombre = SessionManager.vendedorNombre ?? 'Vendedor';

    return Scaffold(
      appBar: CustomBlackAppBar(title: vendedorNombre),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cliente.nombre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Correo: ${cliente.email}"),
            const SizedBox(height: 5),
            Text("Teléfono: ${cliente.telefono}"),
          ],
        ),
      ),
    );
  }
}
