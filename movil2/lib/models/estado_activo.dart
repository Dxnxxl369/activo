// lib/models/estado_activo.dart

class EstadoActivo {
  final int id;
  String nombre;

  EstadoActivo({required this.id, required this.nombre});

  factory EstadoActivo.fromJson(Map<String, dynamic> json) {
    return EstadoActivo(
      id: json['id'],
      nombre: json['nombre'] ?? 'Sin Nombre',
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre};
  }
}