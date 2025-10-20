import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget reutilizable que muestra una fila con etiqueta y valor.
/// Ejemplo:  Fecha del pedido — 2025-10-18
class HeaderRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? labelColor;
  final Color? valueColor;

  const HeaderRow({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: labelColor ?? Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: valueColor ?? Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
