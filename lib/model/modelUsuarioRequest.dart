class UsuarioRequest {
  final String? nombre;
  final String? apellido;
  final String? telefono;
  final String? email;
  final String? password;
  final String? rol;

  UsuarioRequest({
    this.nombre,
    this.apellido,
    this.telefono,
    this.email,
    this.password,
    this.rol,
  });

  // Método para convertir un JSON en un objeto UsuarioRequest
  factory UsuarioRequest.fromJson(Map<String, dynamic> json) {
    return UsuarioRequest(
      nombre: json['nombre'] as String?,
      apellido: json['apellido'] as String?,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      rol: json['rol'] as String?,
    );
  }

  // Método para convertir un objeto UsuarioRequest a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre ?? '',
      'apellido': apellido ?? '',
      'telefono': telefono ?? '',
      'email': email ?? '',
      'password': password ?? '',
      'rol': rol ?? '',
    };
  }
}
