// lib/models/empresa.dart

class Empresa {
  final int id;
  final String nombre;
  final int nit;
  final String direccion;
  final String email;
  final int telefono;

  Empresa({
    required this.id,
    required this.nombre,
    required this.nit,
    required this.direccion,
    required this.email,
    required this.telefono,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'],
      nombre: json['nombre'] ?? 'Sin Nombre',
      nit: json['nit'] ?? 0,
      direccion: json['direccion'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      telefono: json['telefono'] ?? 0,
    );
  }
}