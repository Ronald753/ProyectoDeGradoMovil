class ValoracionProducto {
  final int idValoracionProducto;
  final int valoracion;
  final String comentario;
  final DateTime fechaValoracion;
  final bool estado;
  final DateTime fechaCreacion;
  final int idProducto;
  final int idUsuario;

  ValoracionProducto({
    required this.idValoracionProducto,
    required this.valoracion,
    required this.comentario,
    required this.fechaValoracion,
    required this.estado,
    required this.fechaCreacion,
    required this.idProducto,
    required this.idUsuario,
  });

  // Factory para crear una instancia de ValoracionProducto desde un JSON
  factory ValoracionProducto.fromJson(Map<String, dynamic> json) {
    return ValoracionProducto(
      idValoracionProducto: json['id_valoracion_producto'],
      valoracion: json['valoracion'],
      comentario: json['comentario'],
      fechaValoracion: DateTime.parse(json['fecha_valoracion']),
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      idProducto: json['id_producto'],
      idUsuario: json['id_usuario'],
    );
  }

  // Método para convertir una instancia de ValoracionProducto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_valoracion_producto': idValoracionProducto,
      'valoracion': valoracion,
      'comentario': comentario,
      'fecha_valoracion': fechaValoracion.toIso8601String(),
      'estado': estado,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'id_producto': idProducto,
      'id_usuario': idUsuario,
    };
  }
}

// Modelo de lista para manejar una colección de valoraciones de un producto
class ValoracionProductoResponse {
  final List<ValoracionProducto> valoraciones;

  ValoracionProductoResponse({required this.valoraciones});

  // Factory para crear una instancia de ValoracionProductoResponse desde JSON
  factory ValoracionProductoResponse.fromJson(List<dynamic> jsonList) {
    List<ValoracionProducto> valoraciones = jsonList.map((json) => ValoracionProducto.fromJson(json)).toList();
    return ValoracionProductoResponse(valoraciones: valoraciones);
  }
}
