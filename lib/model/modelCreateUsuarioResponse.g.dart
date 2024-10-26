// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelCreateUsuarioResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioResponse _$UsuarioResponseFromJson(Map<String, dynamic> json) =>
    UsuarioResponse(
      usuario: UsuarioRequest.fromJson(json['usuario'] as Map<String, dynamic>),
      token: json['token'] as String,
    );

Map<String, dynamic> _$UsuarioResponseToJson(UsuarioResponse instance) =>
    <String, dynamic>{
      'usuario': instance.usuario,
      'token': instance.token,
    };
