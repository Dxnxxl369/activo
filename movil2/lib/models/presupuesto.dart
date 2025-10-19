// lib/models/presupuesto.dart

// Modelo para los detalles de asignación
class DetallePresupuesto {
  final int id;
  final String categoriaNombre;
  final String montoAsignado;
  final String fecha;

  DetallePresupuesto({
    required this.id,
    required this.categoriaNombre,
    required this.montoAsignado,
    required this.fecha,
  });

  factory DetallePresupuesto.fromJson(Map<String, dynamic> json) {
    return DetallePresupuesto(
      id: json['id'],
      categoriaNombre: json['categoria_activo']?['nombre'] ?? 'N/A',
      montoAsignado: json['monto_asignado']?.toString() ?? '0.00',
      fecha: json['fecha'] ?? '',
    );
  }
}

class Presupuesto {
  final int id;
  String descripcion;
  String fechaInicio;
  String fechaFin;
  String montoTotal;
  final int empresaId;
  final String empresaNombre;
  final List<DetallePresupuesto> detalles;

  Presupuesto({
    required this.id,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.montoTotal,
    required this.empresaId,
    required this.empresaNombre,
    required this.detalles,
  });

  factory Presupuesto.fromJson(Map<String, dynamic> json) {
    // --- CORRECCIÓN CLAVE: Manejamos si 'empresa' es un ID o un objeto ---
    int empId;
    String empNombre;

    // Tu serializer de Django con `depth=1` envía un objeto, sin `depth` envía un ID.
    // Este código maneja ambos casos.
    if (json['empresa'] is int) {
      empId = json['empresa'];
      empNombre = json['empresa_nombre'] ?? 'ID: ${json['empresa']}';
    } else if (json['empresa'] is Map<String, dynamic>) {
      empId = json['empresa']['id'];
      empNombre = json['empresa']['nombre'] ?? 'Sin Nombre';
    } else {
      empId = 0;
      empNombre = 'N/A';
    }
    
    // Leemos la lista de detalles que envía el backend
    var detallesList = (json['detallepresupuesto_set'] as List? ?? []);
    List<DetallePresupuesto> parsedDetalles = detallesList.map((d) => DetallePresupuesto.fromJson(d)).toList();

    return Presupuesto(
      id: json['id'],
      descripcion: json['descripcion'] ?? 'Sin Descripción',
      fechaInicio: json['fecha_inicio'] ?? '',
      fechaFin: json['fecha_fin'] ?? '',
      montoTotal: json['monto_total']?.toString() ?? '0.00',
      empresaId: empId,
      empresaNombre: empNombre,
      detalles: parsedDetalles,
    );
  }

  // El método toJson no necesita cambios
  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'monto_total': montoTotal,
      'empresa': empresaId,
    };
  }
}