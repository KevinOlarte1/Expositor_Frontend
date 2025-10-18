import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bar/CustomBlackAppBar.dart';

class StatsDetailPage extends StatelessWidget {
  const StatsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // 🔹 fondo de la página
      appBar: const CustomBlackAppBar(
        title: "Histórico pedidos",
        showBack: true,
      ),
      body: const Center(
        child: Text(
          "Aquí mostraremos el histórico 📊",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
