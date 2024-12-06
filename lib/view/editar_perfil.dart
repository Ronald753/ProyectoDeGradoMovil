import 'package:flutter/material.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/model/modelUsuarioRequest.dart'; // Modelo para la actualización del perfil
import 'package:dio/dio.dart';

class EditarPerfil extends StatefulWidget {
  final int idUsuario; // ID del usuario a actualizar

  EditarPerfil({required this.idUsuario});

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _apellido = '';
  String _telefono = '';
  String _email = '';
  
  // Instancia de la API
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio()); // Crear instancia de ApiService
    _cargarDatosUsuario();
  }

  // Función para cargar los datos actuales del usuario
  void _cargarDatosUsuario() async {
    try {
      // Obtener los datos del usuario (asegurándote de que el modelo coincide)
      var usuario = await apiService.getUsuarioPorId(widget.idUsuario);
      setState(() {
        _nombre = usuario.nombre;
        _apellido = usuario.apellido;
        _telefono = usuario.telefono;
        _email = usuario.email;
      });
    } catch (e) {
      print("Error al cargar los datos del usuario: $e");
    }
  }

  // Función para actualizar el perfil
  void _actualizarPerfil() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> usuarioData = {
        'nombre': _nombre,
        'apellido': _apellido,
        'telefono': _telefono,
        'email': _email,
        'rol': 'cliente', // Rol predeterminado
      };

      try {
        // Llamada a la API para actualizar el perfil
        final response = await apiService.actualizarUsuario(widget.idUsuario, usuarioData);

        // Verificar si la respuesta es exitosa (si la API devuelve el modelo EditarUsuarioResponse)
        if (response != null) {
          // Actualizar los datos del perfil con la respuesta del servidor
          setState(() {
            _nombre = response.nombre;
            _apellido = response.apellido;
            _telefono = response.telefono;
            _email = response.email;
          });

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil actualizado')));
          Navigator.pop(context); // Volver a la pantalla anterior
        } else {
          // En caso de que la respuesta no sea válida
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el perfil')));
        }
      } catch (e) {
        // Manejo de errores en caso de que la API falle o haya otro problema
        print("Error al actualizar el perfil: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el perfil')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil"),
        backgroundColor: const Color.fromARGB(255, 75, 96, 112),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    _nombre = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _apellido,
                decoration: InputDecoration(labelText: 'Apellido'),
                onChanged: (value) {
                  setState(() {
                    _apellido = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _telefono,
                decoration: InputDecoration(labelText: 'Teléfono'),
                onChanged: (value) {
                  setState(() {
                    _telefono = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo electrónico';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _actualizarPerfil,
                child: Text('Guardar Cambios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey, // Color del fondo
                  foregroundColor: Colors.white, // Color del texto
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
