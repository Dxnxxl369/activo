// lib/models/activo_fijo.dart

class ActivoFijo {
  final int id;
  String nombre;
  String descripcion;
  String fechaAdquisicion;
  String valorCompra;
  String valorActual;
  
  // IDs de relaciones
  int categoriaId;
  int estadoId;
  int ubicacionId;
  int empresaId;

  // Nombres para mostrar en la UI
  String categoriaNombre;
  String estadoNombre;
  String ubicacionNombre;
  String empresaNombre;

  ActivoFijo({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaAdquisicion,
    required this.valorCompra,
    required this.valorActual,
    required this.categoriaId,
    required this.estadoId,
    required this.ubicacionId,
    required this.empresaId,
    required this.categoriaNombre,
    required this.estadoNombre,
    required this.ubicacionNombre,
    required this.empresaNombre,
  });

  factory ActivoFijo.fromJson(Map<String, dynamic> json) {
    // Manejo de valores nulos para relaciones
    T? getProp<T>(Map<String, dynamic>? obj, String key) => obj != null ? obj[key] : null;

    return ActivoFijo(
      id: json['id'],
      nombre: json['nombre'] ?? 'Sin Nombre',
      descripcion: json['descripcion'] ?? 'Sin Descripción',
      fechaAdquisicion: json['fecha_adquisicion'] ?? '',
      valorCompra: json['valor_compra'].toString(),
      valorActual: json['valor_actual'].toString(),
      categoriaId: getProp(json['categoria_activo'], 'id') ?? 0,
      estadoId: getProp(json['estado'], 'id') ?? 0,
      ubicacionId: getProp(json['ubicacion'], 'id') ?? 0,
      empresaId: getProp(json['empresa'], 'id') ?? 0,
      categoriaNombre: getProp(json['categoria_activo'], 'nombre') ?? 'N/A',
      estadoNombre: getProp(json['estado'], 'nombre') ?? 'N/A',
      ubicacionNombre: getProp(json['ubicacion'], 'nombre') ?? 'N/A',
      empresaNombre: getProp(json['empresa'], 'nombre') ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_adquisicion': fechaAdquisicion,
      'valor_compra': valorCompra,
      'valor_actual': valorActual,
      'categoria_activo': categoriaId,
      'estado': estadoId,
      'ubicacion': ubicacionId,
      'empresa': empresaId,
    };
  }
}