import 'package:flutter/material.dart';
import 'package:restaurante_potosi_app/view/menu.dart';
import 'package:restaurante_potosi_app/view/login.dart';
import 'package:restaurante_potosi_app/view/perfil.dart'; // Asegúrate de importar la pantalla de perfil
import 'package:restaurante_potosi_app/services/secure_storage_service.dart'; // Importa el servicio de almacenamiento seguro

class PantallaInicioBotones extends StatefulWidget {
  const PantallaInicioBotones({super.key});

  @override
  State<PantallaInicioBotones> createState() => _PantallaInicioBotonesState();
}

class _PantallaInicioBotonesState extends State<PantallaInicioBotones> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    PantallaMenu(),
    PantallaPerfil(), // Agregada la pantalla de perfil aquí
  ];

  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<void> _checkUserStatus() async {
    String? userId = await _secureStorageService.obtenerUserId();
    String? token = await _secureStorageService.obtenerToken();

    if (userId == null || token == null) {
      // Si no hay userId o token, navega a la pantalla de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;

            if (_currentPage == 1) { // Cuando se selecciona el ícono de "Perfil"
              _checkUserStatus(); // Llama a la función para verificar el estado del usuario
            }
          });
        },
        unselectedItemColor: Colors.black, // Color para íconos no seleccionados
        selectedItemColor: Colors.red, // Color para ícono seleccionado
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Menú",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
