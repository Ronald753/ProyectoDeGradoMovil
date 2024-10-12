// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelMenuResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuWithProducts _$MenuWithProductsFromJson(Map<String, dynamic> json) =>
    MenuWithProducts(
      menu: Menu.fromJson(json['menu'] as Map<String, dynamic>),
      productos: (json['productos'] as List<dynamic>)
          .map((e) => Productos.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuWithProductsToJson(MenuWithProducts instance) =>
    <String, dynamic>{
      'menu': instance.menu,
      'productos': instance.productos,
    };

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      idMenu: (json['id_menu'] as num).toInt(),
      tipoMenu: json['tipo_menu'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      estado: json['estado'] as bool,
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'id_menu': instance.idMenu,
      'tipo_menu': instance.tipoMenu,
      'fecha_creacion': instance.fechaCreacion.toIso8601String(),
      'estado': instance.estado,
    };

Productos _$ProductosFromJson(Map<String, dynamic> json) => Productos(
      idMenuProducto: (json['id_menu_producto'] as num).toInt(),
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      estado: json['estado'] as bool,
      idMenu: (json['id_menu'] as num).toInt(),
      idProducto: (json['id_producto'] as num).toInt(),
      nombreProducto: json['nombre_producto'] as String,
      precioProducto: (json['precio_producto'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductosToJson(Productos instance) => <String, dynamic>{
      'id_menu_producto': instance.idMenuProducto,
      'fecha_creacion': instance.fechaCreacion.toIso8601String(),
      'estado': instance.estado,
      'id_menu': instance.idMenu,
      'id_producto': instance.idProducto,
      'nombre_producto': instance.nombreProducto,
      'precio_producto': instance.precioProducto,
    };
