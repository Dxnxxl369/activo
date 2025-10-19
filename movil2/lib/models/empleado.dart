// lib/models/empleado.dart

class Empleado {
  final int id;
  final String nombreCompleto;
  final String ci;
  String direccion;
  String telefono;
  
  int cargoId;
  int departamentoId;

  String cargoNombre;
  String departamentoNombre;

  Empleado({
    required this.id,
    required this.nombreCompleto,
    required this.ci,
    required this.direccion,
    required this.telefono,
    required this.cargoId,
    required this.departamentoId,
    required this.cargoNombre,
    required this.departamentoNombre,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    T? getProp<T>(Map<String, dynamic>? obj, String key) => obj != null ? obj[key] : null;

    final usuario = json['usuario'];
    final nombre = usuario != null 
        ? '${usuario['first_name'] ?? ''} ${json['apellido_p'] ?? ''} ${json['apellido_m'] ?? ''}'.trim() 
        : 'Sin Nombre Asignado';

    return Empleado(
      id: json['id'],
      nombreCompleto: nombre,
      ci: json['ci']?.toString() ?? 'N/A',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono']?.toString() ?? '',
      cargoId: getProp(json['cargo'], 'id') ?? 0,
      departamentoId: getProp(json['departamento'], 'id') ?? 0,
      cargoNombre: getProp(json['cargo'], 'nombre') ?? 'Sin Cargo',
      departamentoNombre: getProp(json['departamento'], 'nombre') ?? 'Sin Departamento',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direccion': direccion,
      'telefono': telefono,
      'cargo': cargoId,
      'departamento': departamentoId,
    };
  }
}