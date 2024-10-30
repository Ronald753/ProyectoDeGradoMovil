import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';  // Asegúrate de importar tu archivo de servicio
import 'package:restaurante_potosi_app/model/modelObtenerSugerenciasResponse.dart'; // Asegúrate de importar tu modelo
import 'package:restaurante_potosi_app/model/modelCrearSugerenciaRequest.dart'; // Importa tu modelo de crear sugerencias
import 'package:restaurante_potosi_app/services/secure_storage_service.dart'; // Asegúrate de importar el servicio de almacenamiento seguro

class PantallaSugerencias extends StatefulWidget {
  @override
  _PantallaSugerenciasState createState() => _PantallaSugerenciasState();
}

class _PantallaSugerenciasState extends State<PantallaSugerencias> {
  List<ObtenerSugerencias> sugerencias = []; // Para almacenar las sugerencias
  final ApiService apiService = ApiService(Dio()); // Instancia de tu servicio API
  late SecureStorageService _secureStorageService;

  @override
  void initState() {
    super.initState();
    _secureStorageService = SecureStorageService();
    fetchSugerencias();
  }

  Future<void> fetchSugerencias() async {
    try {
      // Llamada a la API para obtener sugerencias activas
      final response = await apiService.obtenerSugerenciasActivas();
      setState(() {
        sugerencias = response; // Asigna la respuesta a la lista de sugerencias
      });
    } catch (e) {
      print("Error al obtener sugerencias: $e");
      // Aquí podrías mostrar un mensaje de error al usuario si lo deseas
    }
  }

  void _showCreateSugerenciaDialog() async {
    final TextEditingController sugerenciaController = TextEditingController();
    String? userIdString = await _secureStorageService.obtenerUserId();
    int userId = int.tryParse(userIdString ?? '') ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Crear Sugerencia'),
          content: TextField(
            controller: sugerenciaController,
            decoration: InputDecoration(hintText: 'Escribe tu sugerencia aquí'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (sugerenciaController.text.isNotEmpty) {
                  // Crear una nueva sugerencia
                  CrearSugerencia nuevaSugerencia = CrearSugerencia(
                    idUsuario: userId, // Usa el ID del usuario obtenido
                    sugerencia: sugerenciaController.text,
                    fechaSugerencia: DateTime.now(),
                  );

                  try {
                    await apiService.crearSugerencia(nuevaSugerencia);
                    Navigator.of(context).pop(); // Cierra el diálogo
                    fetchSugerencias(); // Actualiza la lista de sugerencias
                  } catch (e) {
                    print("Error al crear sugerencia: $e");
                    // Aquí podrías mostrar un mensaje de error al usuario si lo deseas
                  }
                }
              },
              child: Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sugerencias'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateSugerenciaDialog, // Abre el diálogo al presionar el botón
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sugerencias.length,
        itemBuilder: (context, index) {
          final sugerencia = sugerencias[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sugerencia.sugerencia,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fecha: ${sugerencia.fechaSugerencia}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Usuario: ${sugerencia.nombreUsuario} ${sugerencia.apellidoUsuario}',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
