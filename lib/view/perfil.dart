import 'package:flutter/material.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/services/secure_storage_service.dart';
import 'package:restaurante_potosi_app/view/inicio_botones.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/view/editar_perfil.dart'; // Importa la nueva pantalla de editar perfil

class PantallaPerfil extends StatefulWidget {
  @override
  _PantallaPerfilState createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  late ApiService apiService;
  late SecureStorageService _secureStorageService;

  late int IdUser;
  String _nombre = "";
  String _apellido = "";
  String _telefono = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(contentType: "application/json"));
    apiService = ApiService(dio);
    _secureStorageService = SecureStorageService();
    _obtenerUsuario();
  }

  Future<void> _obtenerUsuario() async {
    try {
      String? userIdString = await _secureStorageService.obtenerUserId();
      int userId = int.tryParse(userIdString ?? '') ?? 0;
      IdUser = userId;

      final usuario = await apiService.getUsuarioPorId(userId);
      setState(() {
        _nombre = usuario.nombre;
        _apellido = usuario.apellido;
        _telefono = usuario.telefono;
        _email = usuario.email;
      });
    } catch (e) {
      print('Error al obtener el usuario: $e');
    }
  }

  Future<void> _logout() async {
    await _secureStorageService.eliminarDatos(); // Eliminar datos de sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PantallaInicioBotones()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Perfil",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 75, 96, 112),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Imagen de perfil
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blueGrey,
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Información del usuario
                  Text(
                    '$_nombre $_apellido',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Teléfono: $_telefono',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: $_email',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  // Botón de editar perfil
                  ElevatedButton(
                    onPressed: () {
                      // Obtener el id y pasar a la pantalla de edición
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPerfil(idUsuario: IdUser), // Pasa el userId
                        ),
                      );
                    },
                    child: Text(
                      "Editar perfil",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey, // Color del fondo
                      foregroundColor: Colors.white, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      elevation: 5,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botón de cerrar sesión
                  ElevatedButton(
                    onPressed: _logout,
                    child: Text(
                      "Cerrar sesión",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Color de fondo
                      foregroundColor: Colors.white, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
