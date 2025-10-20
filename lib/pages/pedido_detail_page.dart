import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pedido.dart';

class PedidoDetailPage extends StatelessWidget {
  final Pedido pedido;

  const PedidoDetailPage({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          "Detalle del Pedido",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white), // ✅ flecha blanca
      ),
      body: Center(
        child: Text(
          "🧾 ID del Pedido: ${pedido.id}",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
