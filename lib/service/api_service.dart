import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/models/pedido.dart';
import '../models/producto.dart';
import '../models/vendedor.dart';
import '../models/cliente.dart';
import '../utils/session_manager.dart';
import '../models/LineaPedido.dart';

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
      return body.map((json) => Pedido.fromJson(json)).toList();
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
      '$baseUrl/api/vendedor/$idVendedor/cliente/$idCliente/pedido/$idPedido/linea',
    );

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => LineaPedido.fromJson(e)).toList();
    } else {
      throw Exception(
        'Error al obtener las líneas del pedido: ${response.statusCode}',
      );
    }
  }
}
