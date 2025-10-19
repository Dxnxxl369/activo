// lib/models/proveedor.dart

class Proveedor {
  final int id;
  String nombre;
  String direccion;
  String telefono;
  String email;
  String estado; // 'activo' o 'inactivo'

  Proveedor({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.estado,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'],
      nombre: json['nombre'] ?? 'Sin Nombre',
      direccion: json['direccion'] ?? 'Sin Dirección',
      telefono: json['telefono'] ?? 'Sin Teléfono',
      email: json['email'] ?? 'Sin Email',
      estado: json['estado'] ?? 'inactivo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'estado': estado,
    };
  }
}