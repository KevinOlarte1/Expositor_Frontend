import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/pedido.dart';
import '../../models/LineaPedido.dart';
import '../../service/api_service.dart';
import '../../utils/session_manager.dart';
import '../../widgets/card/linea_pedido_card.dart';
import '../../widgets/header_row.dart';
import '../../widgets/button/cerrar_pedido_button.dart';

class PedidoDetailPage extends StatefulWidget {
  final Pedido pedido;

  const PedidoDetailPage({super.key, required this.pedido});

  @override
  State<PedidoDetailPage> createState() => _PedidoDetailPageState();
}

class _PedidoDetailPageState extends State<PedidoDetailPage> {
  final ApiService api = ApiService();
  late Future<List<LineaPedido>> lineasFuture;
  late int idVendedor;
  Uint8List? pdfBytes; // 🔹 Guardamos el PDF si existe
  String? localPdfPath; // 🔹 Ruta local para el PDF preview

  @override
  void initState() {
    super.initState();
    idVendedor = SessionManager.getIdVendedro();
    lineasFuture = api.getLineasPedido(
      idVendedor: idVendedor,
      idCliente: widget.pedido.idCliente,
      idPedido: widget.pedido.id,
    );
  }

  Future<void> _loadPdf() async {
    final bytes = await api.fetchPedidoPdf(
      idVendedor: idVendedor,
      idCliente: widget.pedido.idCliente,
      idPedido: widget.pedido.id,
    );

    if (bytes != null) {
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/pedido-${widget.pedido.id}.pdf");
      await file.writeAsBytes(bytes);

      setState(() {
        pdfBytes = bytes;
        localPdfPath = file.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo cargar el PDF del pedido.")),
      );
    }
  }

  Future<void> _downloadPdf() async {
    if (pdfBytes == null) return;

    final dir = await getDownloadsDirectory();
    final file = File("${dir!.path}/pedido-${widget.pedido.id}.pdf");
    await file.writeAsBytes(pdfBytes!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PDF guardado en: ${file.path}"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          'Detalle del Pedido',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<LineaPedido>>(
        future: lineasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final lineas = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              HeaderRow(label: "Fecha del pedido", value: widget.pedido.fecha),
              const Divider(),
              HeaderRow(
                label: "Cliente",
                value: "ID: ${widget.pedido.idCliente}",
              ),
              const Divider(),
              HeaderRow(label: "Notas", value: "—"),
              const Divider(),
              const SizedBox(height: 8),

              if (lineas.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      "No hay productos en este pedido",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else
                ...lineas.map((linea) => LineaPedidoCard(linea: linea)),

              const SizedBox(height: 24),

              CerrarPedidoButton(
                idVendedor: idVendedor,
                idCliente: widget.pedido.idCliente,
                idPedido: widget.pedido.id,
                api: api,
                onClosed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),

              // 🔹 Botón para cargar el PDF (preview)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  "Ver PDF del pedido",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onPressed: _loadPdf,
              ),

              const SizedBox(height: 20),

              if (localPdfPath != null)
                Column(
                  children: [
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: PDFView(
                        filePath: localPdfPath!,
                        enableSwipe: true,
                        autoSpacing: false,
                        swipeHorizontal: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _downloadPdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text("Descargar PDF"),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
