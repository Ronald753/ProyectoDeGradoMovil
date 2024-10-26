import 'package:json_annotation/json_annotation.dart';

part 'modelUsuarioRequest.g.dart';

@JsonSerializable()
class UsuarioRequest {
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String contrasenia;
  final String rol;

  UsuarioRequest({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.contrasenia,
    required this.rol,
  });

  factory UsuarioRequest.fromJson(Map<String, dynamic> json) => _$UsuarioRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioRequestToJson(this);
}
