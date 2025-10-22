import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pedido.dart';
import '../../utils/session_manager.dart';

class PedidoCard extends StatefulWidget {
  final Pedido pedido;
  final VoidCallback? onTap;

  const PedidoCard({super.key, required this.pedido, this.onTap});

  @override
  State<PedidoCard> createState() => _PedidoCardState();
}

class _PedidoCardState extends State<PedidoCard> {
  late int idVendedor;
  bool cargandoTotal = false;

  @override
  void initState() {
    super.initState();
    idVendedor = SessionManager.getIdVendedro();
    _actualizarTotal();
  }

  Future<void> _actualizarTotal() async {
    setState(() => cargandoTotal = true);

    final nuevoTotal = await widget.pedido.calcularTotalDesdeApi(idVendedor);

    setState(() {
      widget.pedido.total = nuevoTotal;
      cargandoTotal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pedido = widget.pedido;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 Información del pedido
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pedido #${pedido.id}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Fecha: ${pedido.fecha}",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                cargandoTotal
                    ? Text(
                        "Calculando total...",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Text(
                        "Total: ${pedido.total?.toStringAsFixed(2) ?? '0.00'} €",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2ECC71), // 💚 Verde suave
                          fontSize: 14,
                        ),
                      ),
              ],
            ),

            // 🔹 Flecha decorativa
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.chevron_right,
                color: Colors.black45,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
