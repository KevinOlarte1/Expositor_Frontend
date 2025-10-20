class LineaPedido {
  final int id;
  final int idPedido;
  final int idProducto;
  final int cantidad;
  final double precio;

  LineaPedido({
    required this.id,
    required this.idPedido,
    required this.idProducto,
    required this.cantidad,
    required this.precio,
  });

  factory LineaPedido.fromJson(Map<String, dynamic> json) {
    return LineaPedido(
      id: json['id'] ?? 0,
      idPedido: json['idPedido'] ?? 0,
      idProducto: json['idProducto'] ?? 0,
      cantidad: json['cantidad'] ?? 0,
      precio: (json['precio'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idPedido': idPedido,
      'idProducto': idProducto,
      'cantidad': cantidad,
      'precio': precio,
    };
  }
}
