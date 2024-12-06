class EditarUsuarioResponse {
  final int id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String rol;
  final bool estado;
  final DateTime fechaCreacion;

  EditarUsuarioResponse({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.rol,
    required this.estado,
    required this.fechaCreacion,
  });

  // Factory constructor para crear un Usuario desde un JSON
  factory EditarUsuarioResponse.fromJson(Map<String, dynamic> json) {
    return EditarUsuarioResponse(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      email: json['email'],
      rol: json['rol'],
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
    );
  }

  // Método para convertir un Usuario a JSON (si necesitas enviar estos datos al servidor)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'email': email,
      'rol': rol,
      'estado': estado,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }
}
