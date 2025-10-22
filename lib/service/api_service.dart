import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mi_app/models/pedido.dart';
import '../models/producto.dart';
import '../models/vendedor.dart';
import '../models/cliente.dart';
import '../utils/session_manager.dart';
import '../models/linea_pedido.dart';
import '../dto/LineaPedioDto.dart';

class ApiService {
  // 🔹 URL base de tu backend (ajústala a tu servidor)
  final String baseUrl = "http://141.253.198.23:8080/api";

  /// 🔹 Obtiene todos los productos
  Future<List<Producto>> getProductos() async {
    final url = Uri.parse('$baseUrl/producto');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Producto.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener productos: ${response.statusCode}");
    }
  }

  /// 🔹 Obtiene un vendedor por su ID
  Future<Vendedor> getVendedor(int idVendedor) async {
    final response = await http.get(Uri.parse("$baseUrl/vendedor/$idVendedor"));

    if (response.statusCode == 200) {
      return Vendedor.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error al cargar el vendedor con ID $idVendedor");
    }
  }

  /// 🔹 Obtiene todos los clientes de un vendedor
  Future<List<Cliente>> getClientesByVendedor(int idVendedor) async {
    final response = await http.get(
      Uri.parse("$baseUrl/vendedor/$idVendedor/cliente"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar clientes del vendedor $idVendedor");
    }
  }

  Future<List<Pedido>> getPedidosByCliente(int idCliente) async {
    final int idVendedor = SessionManager.getIdVendedro();

    final response = await http.get(
      Uri.parse("$baseUrl/vendedor/$idVendedor/cliente/$idCliente/pedido"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      final List<Pedido> pedidos = body
          .map((json) => Pedido.fromJson(json))
          .toList();

      for (var pedido in pedidos) {
        try {
          // Si el pedido no tiene IDs de línea, marcamos total como null directamente
          if (pedido.idLineaPedido.isEmpty) {
            pedido.total = null;
            print("Pedido ${pedido.id} sin líneas → total = null");
            continue;
          }

          final lineas = await getLineasPedido(
            idVendedor: idVendedor,
            idCliente: idCliente,
            idPedido: pedido.id,
          );

          if (lineas.isEmpty) {
            pedido.total = null;
            print("Pedido ${pedido.id} (sin líneas en API) → total = null");
          } else {
            double total = 0;
            for (var linea in lineas) {
              total += (linea.precio ?? 0) * (linea.cantidad ?? 0);
            }
            pedido.total = total;
            print(
              "Pedido ${pedido.id} → ${lineas.length} líneas → total = $total",
            );
          }
        } catch (e) {
          pedido.total = null;
          print("⚠️ Error calculando total del pedido ${pedido.id}: $e");
        }
      }

      return pedidos;
    } else {
      throw Exception(
        "Error al obtener pedidos del cliente (status: ${response.statusCode})",
      );
    }
  }

  Future<Cliente?> addCliente({required String nombre, String? correo}) async {
    final int idVendedor = SessionManager.getIdVendedro();

    final url = Uri.parse("$baseUrl/vendedor/$idVendedor/cliente");

    final Map<String, dynamic> body = {
      "nombre": nombre,
      if (correo != null && correo.isNotEmpty) "correo": correo,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // 🔹 Construimos el Cliente desde ClienteResponseDto
      final cliente = Cliente(
        id: data['id'] ?? 0,
        nombre: data['nombre'] ?? '',
        idVendedor: data['idVendedor'] ?? 0,
        idPedidos: data['idPedidos'] != null
            ? List<int>.from(data['idPedidos'])
            : [],
      );

      return cliente;
    } else {
      print(
        "❌ Error al crear cliente: ${response.statusCode} → ${response.body}",
      );
      return null;
    }
  }

  Future<List<LineaPedido>> getLineasPedido({
    required int idVendedor,
    required int idCliente,
    required int idPedido,
  }) async {
    final url = Uri.parse(
      '$baseUrl/vendedor/$idVendedor/cliente/$idCliente/pedido/$idPedido/linea',
    );

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      //Pruebas imprimir la lista de lineas pedido
      print("idCliente: $idCliente, idPedido: $idPedido");

      // 🧩 Debug: imprimir cada línea recibida
      print("✅ Respuesta correcta: ${jsonList.length} líneas encontradas");
      for (var i = 0; i < jsonList.length; i++) {
        print("— Línea #$i → ${jsonList[i]}");
      }

      return jsonList.map((e) => LineaPedido.fromJson(e)).toList();
    } else {
      print(
        "⚠️ Error ${response.statusCode} obteniendo líneas de pedido $idPedido",
      );
      return [];
    }
  }

  Future<bool> cerrarPedido({
    required int idVendedor,
    required int idCliente,
    required int idPedido,
  }) async {
    final url = Uri.parse(
      '$baseUrl/vendedor/$idVendedor/cliente/$idCliente/pedido/$idPedido/cerrar',
    );

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("✅ Pedido $idPedido cerrado correctamente");
      return true;
    } else {
      print("❌ Error al cerrar pedido $idPedido: ${response.statusCode}");
      return false;
    }
  }

  /// 🔹 Obtiene el PDF de un pedido en bytes (sin guardarlo ni abrirlo)
  Future<Uint8List?> fetchPedidoPdf({
    required int idVendedor,
    required int idCliente,
    required int idPedido,
  }) async {
    final url = Uri.parse(
      '$baseUrl/vendedor/$idVendedor/cliente/$idCliente/pedido/$idPedido/pdf',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("✅ PDF obtenido correctamente para pedido $idPedido");
        return response.bodyBytes;
      } else {
        print(
          "❌ Error ${response.statusCode} al obtener PDF del pedido $idPedido",
        );
        return null;
      }
    } catch (e) {
      print("⚠️ Error al obtener PDF: $e");
      return null;
    }
  }

  /// 🔹 Crear pedido (fecha actual)
  Future<Pedido> crearPedido({
    required int idVendedor,
    required int idCliente,
  }) async {
    final url = Uri.parse(
      "$baseUrl/vendedor/$idVendedor/cliente/$idCliente/pedido",
    );

    final response = await http.post(url);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Pedido.fromJson(body);
    } else {
      throw Exception(
        "Error al crear pedido: ${response.statusCode} ${response.body}",
      );
    }
  }

  /// 🔹 Actualizar fecha del pedido si difiere de la actual
  Future<Pedido> actualizarFechaPedido({
    required int idVendedor,
    required int idCliente,
    required int idPedido,
    required DateTime fecha,
  }) async {
    final fechaStr = fecha.toIso8601String().split('T')[0];
    final url = Uri.parse(
      "$baseUrl/vendedor/$idVendedor/cliente/$idCliente/pedido/$idPedido?fecha=$fechaStr",
    );

    final response = await http.put(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Pedido.fromJson(body);
    } else {
      throw Exception(
        "Error al actualizar fecha: ${response.statusCode} ${response.body}",
      );
    }
  }

  /// 🔹 Añadir línea individual al pedido
  Future<int> addLineaPedido({
    required int idVendedor,
    required int idCliente,
    required int idPedido,
    required LineaPedidoDto linea,
  }) async {
    final url = Uri.parse(
      "$baseUrl/vendedor/$idVendedor/cliente/$idCliente/pedido/$idPedido/linea",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(linea.toJson()),
    );

    return response.statusCode;
  }

  /// 🔹 Eliminar una línea de pedido específica
  Future<bool> deleteLineaPedido({
    required int idVendedor,
    required int idCliente,
    required int idPedido,
    required int idLinea,
  }) async {
    final url = Uri.parse(
      "$baseUrl/vendedor/$idVendedor/cliente/$idCliente/pedido/$idPedido/linea/$idLinea",
    );

    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("🗑️ Línea $idLinea eliminada correctamente del pedido $idPedido");
      return true;
    } else {
      print("❌ Error al eliminar línea $idLinea → ${response.statusCode}");
      return false;
    }
  }
}
