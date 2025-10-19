// lib/models/ubicacion.dart

class Ubicacion {
  final int id;
  String nombre;
  String? direccion;
  String? descripcion;

  Ubicacion({
    required this.id,
    required this.nombre,
    this.direccion,
    this.descripcion,
  });

  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      id: json['id'],
      nombre: json['nombre'] ?? 'Sin Nombre',
      direccion: json['direccion'], // Puede ser nulo
      descripcion: json['descripcion'], // Puede ser nulo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'direccion': direccion,
      'descripcion': descripcion,
    };
  }
}