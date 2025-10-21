import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/api_service.dart';

class CerrarPedidoButton extends StatelessWidget {
  final int idVendedor;
  final int idCliente;
  final int idPedido;
  final ApiService api;
  final VoidCallback? onClosed;

  const CerrarPedidoButton({
    super.key,
    required this.idVendedor,
    required this.idCliente,
    required this.idPedido,
    required this.api,
    this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.lock, color: Colors.white, size: 20),
      label: Text(
        "Cerrar Pedido",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      onPressed: () async {
        final confirmado = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirmar cierre"),
            content: const Text(
              "¿Seguro que deseas cerrar este pedido? Esta acción no se puede deshacer.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text("Cerrar"),
              ),
            ],
          ),
        );

        if (confirmado == true) {
          final exito = await api.cerrarPedido(
            idVendedor: idVendedor,
            idCliente: idCliente,
            idPedido: idPedido,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                exito
                    ? "Pedido cerrado correctamente."
                    : "Error al cerrar el pedido.",
              ),
              backgroundColor: exito ? Colors.green : Colors.redAccent,
            ),
          );

          if (exito && onClosed != null) {
            onClosed!();
          }
        }
      },
    );
  }
}
