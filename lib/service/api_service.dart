import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../models/vendedor.dart';
import '../models/cliente.dart';

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
}
