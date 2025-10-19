// lib/models/departamento.dart

class Departamento {
  final int id;
  String nombre;
  String? descripcion;

  Departamento({
    required this.id, 
    required this.nombre, 
    this.descripcion
  });

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'descripcion': descripcion};
  }
}