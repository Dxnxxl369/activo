// lib/models/empleado.dart

class Empleado {
  final int id;
  final String nombreCompleto;
  final String ci;
  String direccion;
  String telefono;
  
  // IDs para la actualización
  int cargoId;
  int departamentoId;

  // Nombres para mostrar en la UI
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

  // Factory corregido para leer el JSON complejo
  factory Empleado.fromJson(Map<String, dynamic> json) {
    // Función auxiliar para obtener propiedades de objetos anidados de forma segura
    // Evita errores si un objeto como 'cargo' o 'departamento' fuera nulo
    T? getProp<T>(Map<String, dynamic>? obj, String key) => obj != null ? obj[key] : null;

    // 1. Manejamos el objeto 'usuario' anidado
    final usuario = json['usuario'];
    
    // 2. Construimos el nombre completo manualmente
    final nombre = usuario != null 
        ? '${usuario['first_name'] ?? ''} ${json['apellido_p'] ?? ''} ${json['apellido_m'] ?? ''}'.trim() 
        : 'Sin Nombre Asignado';

    return Empleado(
      id: json['id'],
      nombreCompleto: nombre,
      ci: json['ci']?.toString() ?? 'N/A',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono']?.toString() ?? '',
      
      // 3. Leemos los IDs y nombres de los objetos anidados de forma segura
      cargoId: getProp(json['cargo'], 'id') ?? 0,
      departamentoId: getProp(json['departamento'], 'id') ?? 0,
      cargoNombre: getProp(json['cargo'], 'nombre') ?? 'Sin Cargo',
      departamentoNombre: getProp(json['departamento'], 'nombre') ?? 'Sin Departamento',
    );
  }

  // Método para convertir a JSON al momento de actualizar (PUT)
  Map<String, dynamic> toJson() {
    // Para la actualización, solo enviamos los campos que son editables en el móvil
    return {
      'direccion': direccion,
      'telefono': telefono,
      // El backend espera los IDs para las relaciones, no los objetos completos
      'cargo': cargoId,
      'departamento': departamentoId,
    };
  }
}