class Vendedor {
  final int id;
  final String nombre;
  final String email;

  Vendedor({required this.id, required this.nombre, required this.email});

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
    );
  }
}
