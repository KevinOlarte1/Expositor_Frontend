class LineaPedidoDto {
  final int idProducto;
  final int cantidad;
  final double precio;

  LineaPedidoDto({
    required this.idProducto,
    required this.cantidad,
    required this.precio,
  });

  Map<String, dynamic> toJson() => {
    "idProducto": idProducto,
    "cantidad": cantidad,
    "precio": precio,
  };

  @override
  String toString() =>
      "LineaPedidoDto(idProducto: $idProducto, cantidad: $cantidad, precio: $precio)";
}
