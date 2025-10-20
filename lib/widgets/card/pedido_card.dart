import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pedido.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;

  const PedidoCard({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    print(pedido);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blueAccent,
              child: Text(
                pedido.id.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pedido #${pedido.id}",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pedido.fecha,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              pedido.total != null
                  ? "\$${pedido.total!.toStringAsFixed(2)}"
                  : "---",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: pedido.total != null ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
