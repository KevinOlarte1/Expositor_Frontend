import 'package:flutter/material.dart';
import '../widgets/custom_date_picker.dart'; // ✅ Importa el módulo reutilizable

class RealizarVentaPage extends StatefulWidget {
  const RealizarVentaPage({super.key});

  @override
  State<RealizarVentaPage> createState() => _RealizarVentaPageState();
}

class _RealizarVentaPageState extends State<RealizarVentaPage> {
  DateTime fechaVenta = DateTime.now();
  String cliente = "Seleccionar";
  String notas = "";
  List<String> productos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // 🔹 Fondo oscuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white, // 🔹 Flecha blanca
        elevation: 0,
        title: const Text(
          "Realizar venta",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Selector de fecha modularizado
            GestureDetector(
              onTap: () async {
                DateTime? nuevaFecha = await mostrarSelectorFecha(
                  context: context,
                  fechaInicial: fechaVenta,
                );
                if (nuevaFecha != null) {
                  setState(() {
                    fechaVenta = nuevaFecha;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Fecha de venta",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2b2b2b),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Text(
                          formatearFecha(fechaVenta),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.white24),

            // 🔹 Cliente
            _buildListItem(
              title: "Cliente",
              value: cliente,
              onTap: () {
                setState(() {
                  cliente = "Cliente Ejemplo";
                });
              },
            ),

            // 🔹 Notas
            _buildListItem(
              title: "Notas",
              value: notas.isEmpty ? "Añadir" : notas,
              onTap: () {
                setState(() {
                  notas = "Entrega urgente";
                });
              },
            ),

            const SizedBox(height: 16),

            // 🔹 Productos
            GestureDetector(
              onTap: () {
                setState(() {
                  productos = ["Producto A", "Producto B"];
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Productos",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              productos.length.toString(),
                              style: const TextStyle(color: Colors.white54),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.inventory_2, color: Colors.grey, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      productos.isEmpty
                          ? "Seleccionar productos"
                          : productos.join(", "),
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // 🔹 Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Venta guardada correctamente 💾"),
                    ),
                  );
                },
                child: const Text(
                  "Guardar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔸 Método auxiliar para crear filas tipo "Cliente", "Notas", etc.
  Widget _buildListItem({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(color: Colors.white54)),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
          onTap: onTap,
        ),
        const Divider(color: Colors.white24),
      ],
    );
  }
}
