// lib/models/rol.dart

class Permiso {
  final int id;
  final String nombre;

  Permiso({required this.id, required this.nombre});

  factory Permiso.fromJson(Map<String, dynamic> json) {
    return Permiso(id: json['id'], nombre: json['nombre'] ?? 'Sin Nombre');
  }
}

class Rol {
  final int id;
  final String nombre;
  final List<Permiso> permisos;

  Rol({required this.id, required this.nombre, required this.permisos});

  factory Rol.fromJson(Map<String, dynamic> json) {
    // Tu serializer de Rol anida los permisos como una lista de IDs.
    // Para mostrar los nombres, necesitaríamos un serializer anidado en Django.
    // Por ahora, asumimos que el serializer anida los objetos completos.
    var permisosList = (json['permisos'] as List? ?? []);
    // Si 'permisos' es una lista de IDs (ej: [1, 2, 3]), necesitamos un serializer anidado.
    // Si ya es una lista de objetos (ej: [{'id': 1, 'nombre': '...'}, ...]), este código funciona.
    // Vamos a suponer que el serializer de DRF anida los objetos completos para una mejor UI.
    List<Permiso> parsedPermisos = [];
    if (permisosList.isNotEmpty && permisosList.first is Map) {
         parsedPermisos = permisosList.map((p) => Permiso.fromJson(p)).toList();
    }
    
    return Rol(
      id: json['id'],
      nombre: json['nombre'] ?? 'Sin Nombre',
      permisos: parsedPermisos,
    );
  }
}