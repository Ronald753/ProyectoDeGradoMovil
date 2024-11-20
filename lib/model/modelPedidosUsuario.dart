import 'package:json_annotation/json_annotation.dart';

part 'modelPedidosUsuario.g.dart'; // Archivo generado automáticamente con json_serializable

@JsonSerializable(explicitToJson: true)
class PedidosUsuario {
  @JsonKey(name: 'id_pedido')
  final int idPedido;

  @JsonKey(name: 'id_usuario')
  final int idUsuario;

  @JsonKey(name: 'fecha_pedido')
  final DateTime fechaPedido;

  @JsonKey(name: 'tipo_pedido')
  final String tipoPedido;

  @JsonKey(name: 'id_cupon')
  final int? idCupon;

  final String total;

  @JsonKey(name: 'fecha_creacion')
  final DateTime fechaCreacion;

  final bool estado;

  @JsonKey(name: 'estado_pedido')
  final String estadoPedido;

  final List<DetallePedido> detalles;

  PedidosUsuario({
    required this.idPedido,
    required this.idUsuario,
    required this.fechaPedido,
    required this.tipoPedido,
    this.idCupon,
    required this.total,
    required this.fechaCreacion,
    required this.estado,
    required this.estadoPedido,
    required this.detalles,
  });

  factory PedidosUsuario.fromJson(Map<String, dynamic> json) => _$PedidosUsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$PedidosUsuarioToJson(this);
}

@JsonSerializable()
class DetallePedido {
  @JsonKey(name: 'id_detalle_pedido')
  final int idDetallePedido;

  @JsonKey(name: 'id_pedido')
  final int idPedido;

  @JsonKey(name: 'id_producto')
  final int idProducto;

  final int cantidad;

  @JsonKey(name: 'precio_unitario')
  final String precioUnitario;

  final String subtotal;

  @JsonKey(name: 'nombre_producto')
  final String nombreProducto;

  @JsonKey(name: 'precio_producto')
  final double precioProducto;

  @JsonKey(name: 'fecha_creacion')
  final DateTime fechaCreacion;

  final bool estado;

  DetallePedido({
    required this.idDetallePedido,
    required this.idPedido,
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    required this.nombreProducto,
    required this.precioProducto,
    required this.fechaCreacion,
    required this.estado,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) =>
      _$DetallePedidoFromJson(json);

  Map<String, dynamic> toJson() => _$DetallePedidoToJson(this);
}
