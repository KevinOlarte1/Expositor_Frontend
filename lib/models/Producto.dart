class Producto {
  final int id;
  final String descripcion;
  final double precio;

  Producto({required this.id, required this.descripcion, required this.precio});

  // JSON → Producto
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
    );
  }

  // Producto → JSON (por si lo usas luego en POST)
  Map<String, dynamic> toJson() {
    return {'id': id, 'descripcion': descripcion, 'precio': precio};
  }
}
