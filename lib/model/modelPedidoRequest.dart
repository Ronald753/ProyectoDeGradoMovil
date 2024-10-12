class Pedido {
  final int id_usuario;
  final String fecha_pedido;
  final String tipo_pedido;
  final int? id_cupon; // Puede ser null
  final double total;
  final List<DetallePedido> detalles;

  Pedido({
    required this.id_usuario,
    required this.fecha_pedido,
    required this.tipo_pedido,
    this.id_cupon,
    required this.total,
    required this.detalles,
  });

  // Método fromJson para convertir un mapa a un objeto Pedido
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id_usuario: json['id_usuario'],
      fecha_pedido: json['fecha_pedido'],
      tipo_pedido: json['tipo_pedido'],
      id_cupon: json['id_cupon'],
      total: (json['total'] is String) ? double.parse(json['total']) : json['total'],
      detalles: json['detalles'] != null
          ? (json['detalles'] as List)
              .map((detalleJson) => DetallePedido.fromJson(detalleJson))
              .toList()
          : [],  // Retorna una lista vacía si es null
    );
  }

  // Método toJson para convertir el objeto Pedido a un mapa
  Map<String, dynamic> toJson() {
    return {
      'id_usuario': id_usuario,
      'fecha_pedido': fecha_pedido,
      'tipo_pedido': tipo_pedido,
      'id_cupon': id_cupon,
      'total': total,
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
    };
  }
}

class DetallePedido {
  final int id_producto;
  final int cantidad;
  final double precio_unitario;
  final double subtotal;

  DetallePedido({
    required this.id_producto,
    required this.cantidad,
    required this.precio_unitario,
    required this.subtotal,
  });

  // Método fromJson para convertir un mapa a un objeto DetallePedido
  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id_producto: json['id_producto'],
      cantidad: json['cantidad'],
      precio_unitario: (json['precio_unitario'] is String) ? double.parse(json['precio_unitario']) : json['precio_unitario'],
      subtotal: (json['subtotal'] is String) ? double.parse(json['subtotal']) : json['subtotal'],
    );
  }

  // Método toJson para convertir el objeto DetallePedido a un mapa
  Map<String, dynamic> toJson() {
    return {
      'id_producto': id_producto,
      'cantidad': cantidad,
      'precio_unitario': precio_unitario,
      'subtotal': subtotal,
    };
  }
}
