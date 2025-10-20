class Pedido {
  final int id;
  final String
  fecha; // puedes usar DateTime si luego necesitas operaciones de fecha
  final int idCliente;
  final List<int> idLineaPedido;
  final double? total; // opcional hasta que tu API lo devuelva

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

  /// 🔹 Método útil para debug o logs
  @override
  String toString() {
    return 'Pedido(id: $id, fecha: $fecha, idCliente: $idCliente, total: $total, idLinea: $idLineaPedido)';
  }
}
