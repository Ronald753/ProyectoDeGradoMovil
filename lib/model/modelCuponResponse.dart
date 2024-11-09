class Cupon {
  final int idCupon;
  final int idUsuario;
  final String cupon;
  final int porcentajeDescuento;
  final int usosMaximos;
  final int usosDisponibles;
  final bool estado;
  final DateTime fechaCreacion;
  final DateTime? fechaExpiracion; // Campo nullable

  Cupon({
    required this.idCupon,
    required this.idUsuario,
    required this.cupon,
    required this.porcentajeDescuento,
    required this.usosMaximos,
    required this.usosDisponibles,
    required this.estado,
    required this.fechaCreacion,
    this.fechaExpiracion,
  });

  // Método personalizado para serializar JSON a Dart
  factory Cupon.fromJson(Map<String, dynamic> json) {
    return Cupon(
      idCupon: json['id_cupon'] as int,
      idUsuario: json['id_usuario'] as int,
      cupon: json['cupon'] as String,
      porcentajeDescuento: json['porcentaje_descuento'] as int,
      usosMaximos: json['usos_maximos'] as int,
      usosDisponibles: json['usos_disponibles'] as int,
      estado: json['estado'] as bool,
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaExpiracion: json['fecha_expiracion'] != null
          ? DateTime.parse(json['fecha_expiracion'])
          : null,
    );
  }

  // Método personalizado para serializar Dart a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_cupon': idCupon,
      'id_usuario': idUsuario,
      'cupon': cupon,
      'porcentaje_descuento': porcentajeDescuento,
      'usos_maximos': usosMaximos,
      'usos_disponibles': usosDisponibles,
      'estado': estado,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_expiracion': fechaExpiracion?.toIso8601String(),
    };
  }
}
