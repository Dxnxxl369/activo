// lib/models/ubicacion.dart

class Ubicacion {
  final int id;
  String nombre;

  Ubicacion({required this.id, required this.nombre});

  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre};
  }
}