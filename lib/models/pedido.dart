import '../service/api_service.dart';
import 'linea_pedido.dart';

class Pedido {
  final int id;
  final String
  fecha; // puedes usar DateTime si luego necesitas operaciones de fecha
  final int idCliente;
  final List<int> idLineaPedido;
  double? total; // opcional hasta que tu API lo devuelva

  Pedido({
    required this.id,
    required this.fecha,
    required this.idCliente,
    required this.idLineaPedido,
    this.total,
  });

  /// 🔹 Crea un objeto Pedido a partir de un JSON
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] ?? 0,
      fecha: json['fecha'] ?? '',
      idCliente: json['idCliente'] ?? 0,
      idLineaPedido: json['idLineaPedido'] != null
          ? List<int>.from(json['idLineaPedido'])
          : [],
      total: (json['total'] != null)
          ? (json['total'] as num).toDouble()
          : null, // cuando tu API lo tenga
    );
  }

  /// 🔹 Convierte el pedido a JSON (por si necesitas enviarlo)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'idCliente': idCliente,
      'idLineaPedido': idLineaPedido,
      if (total != null) 'total': total,
    };
  }

  /// 🔹 Calcula el total obteniendo las líneas de la API
  Future<double> calcularTotalDesdeApi(int idVendedor) async {
    final api = ApiService();
    double suma = 0.0;

    // Obtenemos las líneas asociadas al pedido
    final lineas = await api.getLineasPedido(
      idVendedor: idVendedor,
      idCliente: idCliente,
      idPedido: id,
    );

    for (var linea in lineas) {
      suma += (linea.precio * linea.cantidad);
    }

    total = suma;
    return suma;
  }

  /// 🔹 Método útil para debug o logs
  @override
  String toString() {
    return 'Pedido(id: $id, fecha: $fecha, idCliente: $idCliente, total: $total, idLinea: $idLineaPedido)';
  }
}
