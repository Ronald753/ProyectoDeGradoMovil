import 'package:flutter/material.dart';
import 'package:restaurante_potosi_app/services/api_service.dart'; // Asegúrate de importar tu servicio
import 'package:restaurante_potosi_app/services/secure_storage_service.dart'; // Asegúrate de importar el servicio de almacenamiento seguro
import 'package:restaurante_potosi_app/view/inicio_botones.dart'; // Importa la página de login
import 'package:dio/dio.dart';

class PantallaPerfil extends StatefulWidget {
  @override
  _PantallaPerfilState createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  late ApiService apiService;
  late SecureStorageService _secureStorageService;

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

      final usuario = await apiService.getUsuarioPorId(userId);
      setState(() {
        _nombre = usuario.nombre;
        _apellido = usuario.apellido;
        _telefono = usuario.telefono;
        _email = usuario.email;
      });
    } catch (e) {
      print('Error al obtener el usuario: $e');
      // Manejar el error (por ejemplo, mostrar un mensaje al usuario)
    }
  }

  Future<void> _logout() async {
    await _secureStorageService.eliminarDatos(); // Eliminar datos de sesión
    // Navegar a la página de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PantallaInicioBotones()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre: $_nombre',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Apellido: $_apellido',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Teléfono: $_telefono',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: $_email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20), // Espacio para separar
                ElevatedButton(
                  onPressed: _logout,
                  child: Text("Cerrar sesión"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Color del botón
                    foregroundColor: Colors.white, // Color del texto
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
