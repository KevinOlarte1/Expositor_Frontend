import 'package:flutter/material.dart';
import '../models/producto.dart';

/// ---------------------------------------------------------------------------
/// 🧾 Selector de Producto con cantidad y precio editable
/// ---------------------------------------------------------------------------
/// Devuelve un mapa con cada producto seleccionado y sus valores:
/// {
///   producto1: { 'cantidad': 2, 'precio': 12.50 },
///   producto2: { 'cantidad': 1, 'precio': 7.99 },
/// }
/// ---------------------------------------------------------------------------

Future<Map<Producto, Map<String, dynamic>>?> mostrarSelectorProducto(
  BuildContext context, {
  required List<Producto> productos,
}) async {
  Map<Producto, Map<String, dynamic>> seleccion = {
    for (var p in productos)
      p: {
        'cantidad': 0,
        'precio': p.precio,
      }, // inicializa con precio por defecto
  };

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1E1E1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: StatefulBuilder(
          builder: (context, setStateModal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Seleccionar productos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: productos.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white24, height: 1),
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      final cantidad = seleccion[producto]!['cantidad'] as int;
                      final precio = seleccion[producto]!['precio'] as double;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              producto.descripcion,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "ID: ${producto.id}",
                              style: const TextStyle(color: Colors.white38),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.white54,
                                  ),
                                  onPressed: () {
                                    if (cantidad > 0) {
                                      setStateModal(() {
                                        seleccion[producto]!['cantidad'] =
                                            cantidad - 1;
                                      });
                                    }
                                  },
                                ),
                                Text(
                                  cantidad.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setStateModal(() {
                                      seleccion[producto]!['cantidad'] =
                                          cantidad + 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          // 🔹 Campo editable de precio
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 8,
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "Precio:",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      hintText: precio.toStringAsFixed(2),
                                      hintStyle: const TextStyle(
                                        color: Colors.white38,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white24,
                                        ),
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 8,
                                          ),
                                    ),
                                    onChanged: (val) {
                                      final nuevoPrecio =
                                          double.tryParse(val) ?? precio;
                                      setStateModal(() {
                                        seleccion[producto]!['precio'] =
                                            nuevoPrecio;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "€",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Eliminar los productos con cantidad = 0
                    seleccion.removeWhere(
                      (_, data) => (data['cantidad'] as int) <= 0,
                    );
                    Navigator.pop(context, seleccion);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Text("Confirmar selección"),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      );
    },
  );

  // Si no hay productos seleccionados, devuelve null
  return seleccion.isEmpty ? null : seleccion;
}
