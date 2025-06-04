class Campaign {
  final int? id; // Cambiado a nullable
  final String titulo;
  final String mensaje;
  final String tipoPromocion;
  final String descuento;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final List<String> productosRelacionados;

  Campaign({
    this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipoPromocion,
    required this.descuento,
    required this.fechaInicio,
    required this.fechaFin,
    required this.productosRelacionados,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] != null ? json['id'] as int : null, // Maneja valores null
      titulo: json['titulo'] ?? '',
      mensaje: json['mensaje'] ?? '',
      tipoPromocion: json['tipo_promocion'] ?? '',
      descuento: json['descuento'] ?? '0',
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
      productosRelacionados: (json['productos_relacionados'] as List<dynamic>?)
              ?.map((producto) => producto['nombre_producto'] as String)
              .toList() ??
          [],
    );
  }
}
