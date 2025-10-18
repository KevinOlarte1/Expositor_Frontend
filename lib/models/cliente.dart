class Cliente {
  final int id;
  final String nombre;
  final int idVendedor;
  final List<int> idPedidos;
  final String email;
  final String telefono;

  Cliente({
    required this.id,
    required this.nombre,
    required this.idVendedor,
    required this.idPedidos,
    this.email = "default@gmail.com",
    this.telefono = "XXX XX XX XX",
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      idVendedor: json['idVendedor'],
      idPedidos: List<int>.from(json['idPedidos'] ?? []),
    );
  }
}
