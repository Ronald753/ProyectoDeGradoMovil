import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class ValoracionProducto {
  final int idValoracionProducto;
  final int valoracion;
  final String comentario;
  final DateTime fechaValoracion;
  final bool estado;
  final DateTime fechaCreacion;
  //final int idProducto;
  final String nombreUsuario;  // Campo nuevo
  final String apellidoUsuario; // Campo nuevo

  ValoracionProducto({
    required this.idValoracionProducto,
    required this.valoracion,
    required this.comentario,
    required this.fechaValoracion,
    required this.estado,
    required this.fechaCreacion,
    //required this.idProducto,
    required this.nombreUsuario,  // Campo nuevo
    required this.apellidoUsuario, // Campo nuevo
  }) {
    // Inicializa la base de datos de zonas horarias al crear una instancia
    tzData.initializeTimeZones();
  }

  // Factory para crear una instancia de ValoracionProducto desde un JSON
  factory ValoracionProducto.fromJson(Map<String, dynamic> json) {
    return ValoracionProducto(
      idValoracionProducto: json['id_valoracion_producto'],
      valoracion: json['valoracion'],
      comentario: json['comentario'],
      fechaValoracion: DateTime.parse(json['fecha_valoracion']),
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      //idProducto: json['id_producto'],
      nombreUsuario: json['nombre_usuario'],  // Campo nuevo
      apellidoUsuario: json['apellido_usuario'], // Campo nuevo
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
      //'id_producto': idProducto,
      'nombre_usuario': nombreUsuario,  // Campo nuevo
      'apellido_usuario': apellidoUsuario, // Campo nuevo
    };
  }

  // Método para formatear la fecha y hora en horario de Bolivia
  String getFormattedFechaValoracion() {
    // Convierte la fecha a la zona horaria de Bolivia (America/La_Paz)
    final boliviaTimeZone = tz.getLocation('America/La_Paz');
    final boliviaDateTime = tz.TZDateTime.from(fechaValoracion.toUtc(), boliviaTimeZone);

    // Formatea la fecha y hora
    return DateFormat('dd/MM/yyyy HH:mm').format(boliviaDateTime);
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
