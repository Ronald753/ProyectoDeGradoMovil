import 'package:flutter/material.dart';
import 'package:restaurante_potosi_app/view/menu.dart';
import 'package:restaurante_potosi_app/view/login.dart';
import 'package:restaurante_potosi_app/view/perfil.dart';
import 'package:restaurante_potosi_app/view/sugerencias.dart';
import 'package:restaurante_potosi_app/view/cupones_pantalla.dart';
import 'package:restaurante_potosi_app/view/inicio.dart'; // Importa la vista de inicio
import 'package:restaurante_potosi_app/services/secure_storage_service.dart';

class PantallaInicioBotones extends StatefulWidget {
  const PantallaInicioBotones({super.key});

  @override
  State<PantallaInicioBotones> createState() => _PantallaInicioBotonesState();
}

class _PantallaInicioBotonesState extends State<PantallaInicioBotones> {
  int _currentPage = 0;

  // Lista de páginas
  final List<Widget> _pages = [
    PantallaMenu(),
    CampanasActivasPage(), // Cambié CampanasActivasPage() por InicioPage()
    PantallaPerfil(),
    PantallaSugerencias(),
    CuponesPage(),
  ];

  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<void> _checkUserStatus() async {
    String? userId = await _secureStorageService.obtenerUserId();
    String? token = await _secureStorageService.obtenerToken();

    if (userId == null || token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
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
          });
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Menú",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign), // Icono para campañas
            label: "Campañas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: "Sugerencias",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Cupones",
          ),
        ],
      ),
    );
  }
}
