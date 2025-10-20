import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/LineaPedido.dart';

/// Widget reutilizable para mostrar una línea de pedido
class LineaPedidoCard extends StatelessWidget {
  final LineaPedido linea;

  const LineaPedidoCard({super.key, required this.linea});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            // ⚠️ Usa una URL real del producto si tu API la provee
            "https://cdn-icons-png.flaticon.com/512/679/679720.png",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          "Producto ID: ${linea.idProducto}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cantidad: ${linea.cantidad}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                "Precio unitario: \$${linea.precio.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        trailing: Text(
          "\$${(linea.precio * linea.cantidad).toStringAsFixed(2)}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
