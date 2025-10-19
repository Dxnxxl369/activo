// lib/models/cargo.dart

class Cargo {
  final int id;
  String nombre;
  String sueldo;

  Cargo({
    required this.id, 
    required this.nombre, 
    required this.sueldo
  });

  factory Cargo.fromJson(Map<String, dynamic> json) {
    return Cargo(
      id: json['id'],
      nombre: json['nombre'],
      sueldo: json['sueldo']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'sueldo': sueldo};
  }
}