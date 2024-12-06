class UserProfile {
  String nombre;
  String apellido;
  String telefono;
  String email;
  String contrasenia;
  String rol;

  UserProfile({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.contrasenia,
    required this.rol,
  });

  // Método para convertir de JSON a un objeto UserProfile
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      telefono: json['telefono'] ?? '',
      email: json['email'] ?? '',
      contrasenia: json['contrasenia'] ?? '',
      rol: json['rol'] ?? '',
    );
  }

  // Método para convertir de un objeto UserProfile a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'email': email,
      'contrasenia': contrasenia,
      'rol': rol,
    };
  }
}
