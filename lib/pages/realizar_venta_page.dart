import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/producto.dart';
import '../service/api_service.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_client_selector.dart';
import '../widgets/custom_product_selector.dart';
import '../dto/LineaPedioDto.dart';
import '../dto/LineaPedioDto.dart';
import '../models/pedido.dart';

class RealizarVentaPage extends StatefulWidget {
  final int idVendedor;

  const RealizarVentaPage({super.key, required this.idVendedor});

  @override
  State<RealizarVentaPage> createState() => _RealizarVentaPageState();
}

class _RealizarVentaPageState extends State<RealizarVentaPage> {
  final ApiService api = ApiService();

  DateTime fechaVenta = DateTime.now();
  Cliente? clienteSeleccionado;
  String notas = "";
  Map<Producto, Map<String, dynamic>> productosSeleccionados = {};

  bool cargandoClientes = false;
  bool cargandoProductos = false;
  List<Cliente> clientes = [];
  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      cargandoClientes = true;
      cargandoProductos = true;
    });
    try {
      clientes = await api.getClientesByVendedor(widget.idVendedor);
      productos = await api.getProductos();
    } catch (e) {
      debugPrint("⚠️ Error al cargar datos: $e");
    } finally {
      setState(() {
        cargandoClientes = false;
        cargandoProductos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargandoClientes || cargandoProductos) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
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
            // 🔹 Fecha
            GestureDetector(
              onTap: () async {
                DateTime? nuevaFecha = await mostrarSelectorFecha(
                  context: context,
                  fechaInicial: fechaVenta,
                );
                if (nuevaFecha != null) {
                  setState(() => fechaVenta = nuevaFecha);
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
              value: clienteSeleccionado?.nombre ?? "Seleccionar",
              onTap: () async {
                Cliente? nuevo = await mostrarSelectorCliente(
                  context,
                  clientes: clientes,
                  clienteActual: clienteSeleccionado,
                );
                if (nuevo != null) {
                  setState(() => clienteSeleccionado = nuevo);
                }
              },
            ),

            // 🔹 Notas
            _buildListItem(
              title: "Notas",
              value: notas.isEmpty ? "Añadir" : notas,
              onTap: () {
                setState(() => notas = "Entrega urgente");
              },
            ),

            const SizedBox(height: 16),

            // 🔹 Productos con cantidad y precio editable
            GestureDetector(
              onTap: () async {
                final seleccion = await mostrarSelectorProducto(
                  context,
                  productos: productos,
                );

                if (seleccion != null) {
                  setState(() => productosSeleccionados = seleccion);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              productosSeleccionados.length.toString(),
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
                    const SizedBox(height: 16),

                    if (productosSeleccionados.isEmpty)
                      const Text(
                        "Seleccionar productos",
                        style: TextStyle(color: Colors.white60),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: productosSeleccionados.entries.map((e) {
                          final producto = e.key;
                          final cantidad = e.value['cantidad'] as int;
                          final precio = e.value['precio'] as double;
                          final total = cantidad * precio;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              "${producto.descripcion} x$cantidad → "
                              "${precio.toStringAsFixed(2)} € c/u = "
                              "${total.toStringAsFixed(2)} €",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          );
                        }).toList(),
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
                onPressed: _guardarVenta,
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

  /// 🔹 Guardar la venta (validación y confirmación)
  Future<void> _guardarVenta() async {
    if (clienteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona un cliente antes de guardar ⚠️"),
        ),
      );
      return;
    }

    if (productosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona al menos un producto ⚠️")),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Creando pedido... ⏳")));

    try {
      // 🔹 Paso 1: Crear pedido
      Pedido pedido = await api.crearPedido(
        idVendedor: widget.idVendedor,
        idCliente: clienteSeleccionado!.id,
      );

      int idPedido = pedido.id;

      // 🔹 Paso 2: Si la fecha difiere, actualizarla
      final hoy = DateTime.now();
      final mismaFecha =
          fechaVenta.year == hoy.year &&
          fechaVenta.month == hoy.month &&
          fechaVenta.day == hoy.day;

      if (!mismaFecha) {
        pedido = await api.actualizarFechaPedido(
          idVendedor: widget.idVendedor,
          idCliente: clienteSeleccionado!.id,
          idPedido: idPedido,
          fecha: fechaVenta,
        );
        idPedido = pedido.id;
        debugPrint("📅 Pedido actualizado con fecha ${pedido.fecha}");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Añadiendo líneas de pedido... 📦")),
      );

      // 🔹 Paso 3: Añadir líneas una a una
      for (var entry in productosSeleccionados.entries) {
        final producto = entry.key;
        final cantidad = entry.value['cantidad'] as int;
        final precio = entry.value['precio'] as double;

        final linea = LineaPedidoDto(
          idProducto: producto.id,
          cantidad: cantidad,
          precio: precio,
        );

        final status = await api.addLineaPedido(
          idVendedor: widget.idVendedor,
          idCliente: clienteSeleccionado!.id,
          idPedido: idPedido,
          linea: linea,
        );

        if (status != 200 && status != 201) {
          throw Exception(
            "Error al guardar línea del producto ${producto.descripcion}",
          );
        }

        debugPrint("✅ Línea guardada: ${linea.toString()}");
      }
      // 🔹 Pedido completado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pedido #$idPedido guardado correctamente ✅"),
          duration: const Duration(seconds: 2),
        ),
      );

      // 🔹 Esperamos un momento y volvemos atrás
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        Navigator.pop(context, true); // ← Devuelve “true” para indicar éxito
      }
    } catch (e) {
      debugPrint("❌ Error al guardar venta: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al guardar venta: $e")));
    }
  }

  /// 🔹 Widget genérico para filas de selección (cliente, notas, etc.)
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
