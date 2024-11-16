class Sugerencia {
  final int idSugerencia;
  final int idUsuario;
  final String sugerencia;
  final DateTime fechaSugerencia;
  final bool estado;
  final DateTime fechaCreacion;
  final String nombreUsuario;
  final String apellidoUsuario;

  Sugerencia({
    required this.idSugerencia,
    required this.idUsuario,
    required this.sugerencia,
    required this.fechaSugerencia,
    required this.estado,
    required this.fechaCreacion,
    required this.nombreUsuario,
    required this.apellidoUsuario,
  });

  // Factory para crear una instancia a partir de un JSON
  factory Sugerencia.fromJson(Map<String, dynamic> json) {
    return Sugerencia(
      idSugerencia: json['id_sugerencia'],
      idUsuario: json['id_usuario'],
      sugerencia: json['sugerencia'],
      fechaSugerencia: DateTime.parse(json['fecha_sugerencia']),
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      nombreUsuario: json['nombre_usuario'],
      apellidoUsuario: json['apellido_usuario'],
    );
  }

  // Método para convertir una instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_sugerencia': idSugerencia,
      'id_usuario': idUsuario,
      'sugerencia': sugerencia,
      'fecha_sugerencia': fechaSugerencia.toIso8601String(),
      'estado': estado,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'nombre_usuario': nombreUsuario,
      'apellido_usuario': apellidoUsuario,
    };
  }
}
