// lib/models/activo_fijo.dart

class ActivoFijo {
  final int id;
  String nombre;
  final int codigoInterno;
  String fechaAdquisicion;
  String valorActual;
  int vidaUtil;
  
  // IDs para relaciones
  int empresaId;
  int estadoId;
  int categoriaId;
  int ubicacionId;

  // Nombres para mostrar en la UI
  String empresaNombre;
  String estadoNombre;
  String categoriaNombre;
  String ubicacionNombre;

  ActivoFijo({
    required this.id,
    required this.nombre,
    required this.codigoInterno,
    required this.fechaAdquisicion,
    required this.valorActual,
    required this.vidaUtil,
    required this.empresaId,
    required this.estadoId,
    required this.categoriaId,
    required this.ubicacionId,
    required this.empresaNombre,
    required this.estadoNombre,
    required this.categoriaNombre,
    required this.ubicacionNombre,
  });

  factory ActivoFijo.fromJson(Map<String, dynamic> json) {
    T? getProp<T>(Map<String, dynamic>? obj, String key) => obj != null ? obj[key] : null;

    return ActivoFijo(
      id: json['id'],
      nombre: json['nombre'] ?? 'Sin Nombre',
      codigoInterno: json['codigo_interno'] ?? 0,
      fechaAdquisicion: json['fecha_adquisicion'] ?? '',
      valorActual: json['valor_actual']?.toString() ?? '0.00',
      vidaUtil: json['vida_util'] ?? 0,
      empresaId: getProp(json['empresa'], 'id') ?? 0,
      estadoId: getProp(json['estado'], 'id') ?? 0,
      // CORRECCIÓN: Tu modelo en Django usa 'categoria', no 'categoria_activo'
      categoriaId: getProp(json['categoria'], 'id') ?? 0, 
      ubicacionId: getProp(json['ubicacion'], 'id') ?? 0,
      empresaNombre: getProp(json['empresa'], 'nombre') ?? 'N/A',
      estadoNombre: getProp(json['estado'], 'nombre') ?? 'N/A',
      categoriaNombre: getProp(json['categoria'], 'nombre') ?? 'N/A',
      ubicacionNombre: getProp(json['ubicacion'], 'nombre') ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'codigo_interno': codigoInterno,
      'fecha_adquisicion': fechaAdquisicion,
      'valor_actual': valorActual,
      'vida_util': vidaUtil,
      'empresa': empresaId,
      'estado': estadoId,
      'categoria': categoriaId,
      'ubicacion': ubicacionId,
    };
  }
}