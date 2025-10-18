import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final Color buttonColor;
  final VoidCallback onPressed;

  const CustomActionButton({
    super.key,
    required this.text,
    required this.icon,
    this.iconBackground = const Color(0xFF2A1D1D), // 🔹 fondo icono
    this.iconColor = const Color(0xFFFF5963), // 🔹 color icono
    this.buttonColor = const Color(0xFF2b2b2b), // 🔹 fondo botón
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔹 Icono con fondo
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
