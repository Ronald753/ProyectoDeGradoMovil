import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/model/modelUsuarioRequest.dart';
import 'package:validators/validators.dart';
import 'package:restaurante_potosi_app/view/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _contraseniaController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _contraseniaController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final user = UsuarioRequest(
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        telefono: _telefonoController.text,
        email: _emailController.text,
        password: _contraseniaController.text,
        rol: 'cliente',
      );

      final dio = Dio();
      final apiService = ApiService(dio);

      try {
        final response = await apiService.createUser(user);
        // Aquí puedes acceder tanto al usuario como al token
        final createdUser = response.usuario; // Usuario creado
        final token = response.token; // Token de autenticación

        // Manejo de la respuesta
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario creado: ${createdUser.nombre}")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al crear usuario: $e")),
        );
        print("Error al crear usuario: $e");
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    } else if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$').hasMatch(value)) {
      return 'Debe incluir letras, números y un caracter especial';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario', 
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        backgroundColor: const Color.fromARGB(255, 75, 96, 112),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apellidoController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _telefonoController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu teléfono';
                    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Solo se permiten números';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu email';
                    } else if (!isEmail(value)) {
                      return 'Por favor ingresa un email válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contraseniaController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: _validatePassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Registrar Usuario',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Color de fondo
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
