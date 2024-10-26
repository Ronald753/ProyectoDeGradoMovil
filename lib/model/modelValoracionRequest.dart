class ValoracionProductoRequest {
  final int idProducto;
  final int idUsuario;
  final int valoracion;
  final String comentario;

  ValoracionProductoRequest({
    required this.idProducto,
    required this.idUsuario,
    required this.valoracion,
    required this.comentario,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'id_usuario': idUsuario,
      'valoracion': valoracion,
      'comentario': comentario,
    };
  }
}
