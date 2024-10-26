class LoginResponse {
  final String message;
  final User user;
  final String token; // Cambiamos 'access' y 'refresh' por 'token'

  LoginResponse({
    required this.message,
    required this.user,
    required this.token, // Cambiamos 'access' y 'refresh' por 'token'
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      user: User.fromJson(json['user']),
      token: json['token'], // Cambiamos 'access' y 'refresh' por 'token'
    );
  }
}

class User {
  final int id; // Cambié el nombre de la variable a 'id' para que coincida con el JSON
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String rol;
  final DateTime fechaCreacion;
  final bool estado;

  User({
    required this.id, // Cambié 'idUsuario' a 'id'
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.rol,
    required this.fechaCreacion,
    required this.estado,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Cambié 'id_usuario' a 'id'
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      email: json['email'],
      rol: json['rol'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      estado: json['estado'],
    );
  }
}
