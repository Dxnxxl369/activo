// lib/models/rol.dart

class Permiso {
  final int id;
  final String nombre;
  Permiso({required this.id, required this.nombre});
  factory Permiso.fromJson(Map<String, dynamic> json) {
    return Permiso(id: json['id'], nombre: json['nombre']);
  }
}

class Rol {
  final int id;
  final String nombre;
  final List<Permiso> permisos;

  Rol({required this.id, required this.nombre, required this.permisos});

  factory Rol.fromJson(Map<String, dynamic> json) {
    var permisosList = json['permisos'] as List;
    List<Permiso> permisos = permisosList.map((p) => Permiso.fromJson(p)).toList();
    return Rol(
      id: json['id'],
      nombre: json['nombre'],
      permisos: permisos,
    );
  }
}