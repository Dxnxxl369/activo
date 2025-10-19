// lib/models/categoria_activo.dart

class CategoriaActivo {
  final int id;
  String nombre;

  CategoriaActivo({required this.id, required this.nombre});

  factory CategoriaActivo.fromJson(Map<String, dynamic> json) {
    return CategoriaActivo(id: json['id'], nombre: json['nombre']);
  }

  Map<String, dynamic> toJson() => {'nombre': nombre};
}