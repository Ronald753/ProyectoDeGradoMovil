class Producto {
  final int idProducto;
  final int idCategoria;
  final String nombreProducto;
  final String descripcion;
  final double? precio; // Permitir null
  final String? imagenUrl; // Añadido campo imagenUrl
  final bool estado;
  final DateTime fechaCreacion;
  final List<Ingrediente> ingredientes;

  Producto({
    required this.idProducto,
    required this.idCategoria,
    required this.nombreProducto,
    required this.descripcion,
    this.precio, // Mantenerlo opcional
    this.imagenUrl, // Añadido este campo opcional
    required this.estado,
    required this.fechaCreacion,
    required this.ingredientes,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'],
      idCategoria: json['id_categoria'],
      nombreProducto: json['nombre_producto'],
      descripcion: json['descripcion'],
      precio: (json['precio'] != null) ? json['precio'].toDouble() : null, // Manejar null
      imagenUrl: json['imagen_url'], // Asignar el valor de imagen_url
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      ingredientes: (json['ingredientes'] as List)
          .map((i) => Ingrediente.fromJson(i))
          .toList(),
    );
  }
}

class Ingrediente {
  final int idIngrediente;
  final String nombreIngrediente;
  final String descripcionIngrediente;
  final bool estado;

  Ingrediente({
    required this.idIngrediente,
    required this.nombreIngrediente,
    required this.descripcionIngrediente,
    required this.estado,
  });

  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(
      idIngrediente: json['id_ingrediente'],
      nombreIngrediente: json['nombre_ingrediente'],
      descripcionIngrediente: json['descripcion_ingrediente'],
      estado: json['estado'],
    );
  }
}
