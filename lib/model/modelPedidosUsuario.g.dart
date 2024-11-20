// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelPedidosUsuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedidosUsuario _$PedidosUsuarioFromJson(Map<String, dynamic> json) =>
    PedidosUsuario(
      idPedido: (json['id_pedido'] as num).toInt(),
      idUsuario: (json['id_usuario'] as num).toInt(),
      fechaPedido: DateTime.parse(json['fecha_pedido'] as String),
      tipoPedido: json['tipo_pedido'] as String,
      idCupon: (json['id_cupon'] as num?)?.toInt(),
      total: json['total'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      estado: json['estado'] as bool,
      estadoPedido: json['estado_pedido'] as String,
      detalles: (json['detalles'] as List<dynamic>)
          .map((e) => DetallePedido.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PedidosUsuarioToJson(PedidosUsuario instance) =>
    <String, dynamic>{
      'id_pedido': instance.idPedido,
      'id_usuario': instance.idUsuario,
      'fecha_pedido': instance.fechaPedido.toIso8601String(),
      'tipo_pedido': instance.tipoPedido,
      'id_cupon': instance.idCupon,
      'total': instance.total,
      'fecha_creacion': instance.fechaCreacion.toIso8601String(),
      'estado': instance.estado,
      'estado_pedido': instance.estadoPedido,
      'detalles': instance.detalles.map((e) => e.toJson()).toList(),
    };

DetallePedido _$DetallePedidoFromJson(Map<String, dynamic> json) =>
    DetallePedido(
      idDetallePedido: (json['id_detalle_pedido'] as num).toInt(),
      idPedido: (json['id_pedido'] as num).toInt(),
      idProducto: (json['id_producto'] as num).toInt(),
      cantidad: (json['cantidad'] as num).toInt(),
      precioUnitario: json['precio_unitario'] as String,
      subtotal: json['subtotal'] as String,
      nombreProducto: json['nombre_producto'] as String,
      precioProducto: (json['precio_producto'] as num).toDouble(),
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      estado: json['estado'] as bool,
    );

Map<String, dynamic> _$DetallePedidoToJson(DetallePedido instance) =>
    <String, dynamic>{
      'id_detalle_pedido': instance.idDetallePedido,
      'id_pedido': instance.idPedido,
      'id_producto': instance.idProducto,
      'cantidad': instance.cantidad,
      'precio_unitario': instance.precioUnitario,
      'subtotal': instance.subtotal,
      'nombre_producto': instance.nombreProducto,
      'precio_producto': instance.precioProducto,
      'fecha_creacion': instance.fechaCreacion.toIso8601String(),
      'estado': instance.estado,
    };
