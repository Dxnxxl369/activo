// lib/models/proveedor.dart

class Proveedor {
  final int id;
  String nombre;
  String nit;
  String? direccion;
  String? email;
  String? pais;
  String estado;

  Proveedor({
    required this.id,
    required this.nombre,
    required this.nit,
    this.direccion,
    this.email,
    this.pais,
    required this.estado,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'],
      nombre: json['nombre'] ?? 'Sin Nombre',
      nit: json['nit']?.toString() ?? 'N/A',
      direccion: json['direccion'],
      email: json['email'],
      pais: json['pais'],
      estado: json['estado'] ?? 'inactivo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'nit': nit,
      'direccion': direccion,
      'email': email,
      'pais': pais,
      'estado': estado,
    };
  }
}