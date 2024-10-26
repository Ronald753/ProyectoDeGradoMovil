import 'package:json_annotation/json_annotation.dart';
import 'package:restaurante_potosi_app/model/modelUsuarioRequest.dart';

part 'modelCreateUsuarioResponse.g.dart';

@JsonSerializable()
class UsuarioResponse {
  final UsuarioRequest usuario; // Asegúrate de tener la clase UsuarioRequest importada
  final String token;

  UsuarioResponse({
    required this.usuario,
    required this.token,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) => _$UsuarioResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioResponseToJson(this);
}
