class ObtenerSugerencias {
  final int idSugerencia;
  final int idUsuario;
  final String sugerencia;
  final DateTime fechaSugerencia;
  final bool estado;
  final DateTime fechaCreacion;
  final String nombreUsuario;  // Nuevo campo para el nombre del usuario
  final String apellidoUsuario; // Nuevo campo para el apellido del usuario

  ObtenerSugerencias({
    required this.idSugerencia,
    required this.idUsuario,
    required this.sugerencia,
    required this.fechaSugerencia,
    required this.estado,
    required this.fechaCreacion,
    required this.nombreUsuario,   // Inicializa el nuevo campo
    required this.apellidoUsuario,  // Inicializa el nuevo campo
  });

  factory ObtenerSugerencias.fromJson(Map<String, dynamic> json) {
    return ObtenerSugerencias(
      idSugerencia: json['id_sugerencia'],
      idUsuario: json['id_usuario'],
      sugerencia: json['sugerencia'],
      fechaSugerencia: DateTime.parse(json['fecha_sugerencia']),
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      nombreUsuario: json['nombre_usuario'],   // Asigna el nombre del usuario
      apellidoUsuario: json['apellido_usuario'], // Asigna el apellido del usuario
    );
  }
}
