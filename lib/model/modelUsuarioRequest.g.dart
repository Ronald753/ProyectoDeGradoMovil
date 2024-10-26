// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelUsuarioRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioRequest _$UsuarioRequestFromJson(Map<String, dynamic> json) =>
    UsuarioRequest(
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      telefono: json['telefono'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      rol: json['rol'] as String,
    );

Map<String, dynamic> _$UsuarioRequestToJson(UsuarioRequest instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'telefono': instance.telefono,
      'email': instance.email,
      'password': instance.password,
      'rol': instance.rol,
    };
