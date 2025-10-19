// lib/models/presupuesto.dart

class Presupuesto {
  final int id;
  String descripcion;
  String fechaInicio;
  String fechaFin;
  String montoTotal;
  final int empresaId;
  final String empresaNombre;

  Presupuesto({
    required this.id,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.montoTotal,
    required this.empresaId,
    required this.empresaNombre,
  });

  // Factory para crear una instancia desde un mapa JSON
  factory Presupuesto.fromJson(Map<String, dynamic> json) {
    return Presupuesto(
      id: json['id'],
      descripcion: json['descripcion'],
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      montoTotal: json['monto_total'].toString(),
      // El backend devuelve un objeto empresa, accedemos a sus propiedades
      empresaId: json['empresa']['id'],
      empresaNombre: json['empresa']['nombre'],
    );
  }

  // Método para convertir la instancia a un mapa JSON para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'monto_total': montoTotal,
      // Al actualizar, solo necesitamos enviar el ID de la empresa
      'empresa': empresaId,
    };
  }
}