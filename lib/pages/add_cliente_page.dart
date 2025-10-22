import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/api_service.dart';

class AddClientePage extends StatelessWidget {
  const AddClientePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController correoController = TextEditingController();
    final ApiService api = ApiService();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Añadir cliente",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final nombre = nombreController.text.trim();
              final correo = correoController.text.trim();

              if (nombre.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Por favor introduce un nombre ⚠️"),
                  ),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Creando cliente... ⏳")),
              );

              // 🔹 Llama al método que ahora devuelve Cliente? (no bool)
              final cliente = await api.addCliente(
                nombre: nombre,
                correo: correo.isNotEmpty ? correo : null,
              );

              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (cliente != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Cliente creado correctamente ✅"),
                    backgroundColor: Colors.green,
                  ),
                );

                // 🔹 Devuelve el cliente al DashboardPage
                Navigator.pop(context, cliente);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Error al crear el cliente ❌"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: Text(
              "Guardar",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Campo: Nombre
              Text(
                "Nombre",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  hintText: "Introduce el nombre del cliente",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 24),

              // 🔹 Campo: Correo electrónico (opcional)
              Text(
                "Correo electrónico (opcional)",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: correoController,
                decoration: InputDecoration(
                  hintText: "Introduce el correo del cliente (si aplica)",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
