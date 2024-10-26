import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurante_potosi_app/services/api_service.dart'; // Asegúrate de importar tu ApiService
import 'package:restaurante_potosi_app/model/modelLoginRequest.dart'; // Importa tu modelo de login
import 'package:restaurante_potosi_app/view/inicio_botones.dart';
import 'package:restaurante_potosi_app/view/registro.dart'; // Importa la pantalla de registro

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
  try {
    LoginRequest loginRequest = LoginRequest(email: email, password: password);
    var response = await ApiService(Dio()).login(loginRequest.toJson());

    if (response != null && response.message == 'Login exitoso') {
      // Guardar el ID del usuario y el token en almacenamiento seguro
      await storage.write(key: 'userId', value: response.user.id.toString());
      await storage.write(key: 'token', value: response.token);

      // Navegar a la pantalla de menú
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaInicioBotones(),
        ),
      );
    } else {
      _showErrorDialog('Error: ${response.message}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      String errorMessage = e.response?.data['message'] ?? 'Error en la conexión. Intenta de nuevo.';
      _showErrorDialog(errorMessage);
    } else {
      _showErrorDialog('Error en la conexión. Intenta de nuevo.');
    }
  } catch (e) {
    _showErrorDialog('Error inesperado: $e');
    print('Error inesperado: $e');
  }
}

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Iniciar Sesión'),
              onPressed: () {
                String email = _emailController.text;
                String password = _passwordController.text;
                login(email, password);
              },
            ),
            SizedBox(height: 20),
            TextButton(
              child: Text('Crear Usuario'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(), // Redirige a la pantalla de registro
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
