import 'package:json_annotation/json_annotation.dart';

part 'modelMenuResponse.g.dart'; // Asegúrate de que el nombre coincida con el archivo de modelo

@JsonSerializable()
class MenuWithProducts {
  final Menu menu;
  final List<Productos> productos;

  MenuWithProducts({required this.menu, required this.productos});

  factory MenuWithProducts.fromJson(Map<String, dynamic> json) =>
      _$MenuWithProductsFromJson(json);

  Map<String, dynamic> toJson() => _$MenuWithProductsToJson(this);
}

@JsonSerializable()
class Menu {
  @JsonKey(name: 'id_menu') // Mapeo de nombre de campo
  final int idMenu;

  @JsonKey(name: 'tipo_menu') // Mapeo de nombre de campo
  final String tipoMenu;

  @JsonKey(name: 'fecha_creacion') // Mapeo de nombre de campo
  final DateTime fechaCreacion;

  final bool estado;

  Menu({
    required this.idMenu,
    required this.tipoMenu,
    required this.fechaCreacion,
    required this.estado,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}

@JsonSerializable()
class Productos {
  @JsonKey(name: 'id_menu_producto') // Mapeo de nombre de campo
  final int idMenuProducto;

  @JsonKey(name: 'fecha_creacion') // Mapeo de nombre de campo
  final DateTime fechaCreacion;

  final bool estado;

  @JsonKey(name: 'id_menu') // Mapeo de nombre de campo
  final int idMenu;

  @JsonKey(name: 'id_producto') // Mapeo de nombre de campo
  final int idProducto;

  @JsonKey(name: 'nombre_producto') // Mapeo de nombre de campo
  final String nombreProducto;

  @JsonKey(name: 'precio_producto') // Mapeo de nombre de campo
  final double precioProducto;

  @JsonKey(name: 'imagen_url') // Nuevo campo para la URL de la imagen
  final String imagenUrl;

  Productos({
    required this.idMenuProducto,
    required this.fechaCreacion,
    required this.estado,
    required this.idMenu,
    required this.idProducto,
    required this.nombreProducto,
    required this.precioProducto,
    required this.imagenUrl,
  });

  factory Productos.fromJson(Map<String, dynamic> json) {
    return Productos(
      idMenuProducto: json['id_menu_producto'] as int,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      estado: json['estado'] as bool,
      idMenu: json['id_menu'] as int,
      idProducto: json['id_producto'] as int,
      nombreProducto: json['nombre_producto'] as String,
      precioProducto: (json['precio_producto'] as num?)?.toDouble() ?? 0.0,
      imagenUrl: json['imagen_url'] as String, // Maneja el campo imagen_url
    );
  }

  Map<String, dynamic> toJson() => _$ProductosToJson(this);
}
