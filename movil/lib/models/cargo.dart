// lib/models/cargo.dart

class Cargo {
  final int id;
  String nombre;

  Cargo({required this.id, required this.nombre});

  factory Cargo.fromJson(Map<String, dynamic> json) {
    return Cargo(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre};
  }
}