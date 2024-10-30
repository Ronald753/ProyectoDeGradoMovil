class CrearSugerencia {
  final int idUsuario; // Asegúrate de que este campo sea requerido en tu API
  final String sugerencia;
  final DateTime fechaSugerencia; // Nuevo campo

  CrearSugerencia({
    required this.idUsuario,
    required this.sugerencia,
    required this.fechaSugerencia, // Agrega el nuevo campo
  });

  Map<String, dynamic> toJson() => {
        'id_usuario': idUsuario,
        'sugerencia': sugerencia,
        'fecha_sugerencia': fechaSugerencia.toIso8601String(), // Convierte a formato ISO 8601
      };
}
