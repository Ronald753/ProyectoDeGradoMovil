import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/model/modelObtenerSugerenciasResponse.dart';
import 'package:restaurante_potosi_app/model/modelSugerenciasUsuarioResponse.dart';
import 'package:restaurante_potosi_app/model/modelCrearSugerenciaRequest.dart';
import 'package:restaurante_potosi_app/services/secure_storage_service.dart';
import 'package:intl/intl.dart';

class PantallaSugerencias extends StatefulWidget {
  @override
  _PantallaSugerenciasState createState() => _PantallaSugerenciasState();
}

class _PantallaSugerenciasState extends State<PantallaSugerencias> {
  List<ObtenerSugerencias> sugerencias = [];
  final ApiService apiService = ApiService(Dio());
  late SecureStorageService _secureStorageService;

  @override
  void initState() {
    super.initState();
    _secureStorageService = SecureStorageService();
    fetchSugerencias();
  }

  Future<void> fetchSugerencias() async {
    try {
      final response = await apiService.obtenerSugerenciasActivas();
      setState(() {
        sugerencias = response;
      });
    } catch (e) {
      print("Error al obtener sugerencias: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (sugerenciaController.text.isNotEmpty) {
                  CrearSugerencia nuevaSugerencia = CrearSugerencia(
                    idUsuario: userId,
                    sugerencia: sugerenciaController.text,
                    fechaSugerencia: DateTime.now(),
                  );

                  try {
                    await apiService.crearSugerencia(nuevaSugerencia);
                    Navigator.of(context).pop();
                    fetchSugerencias();
                    _showSnackBar('Sugerencia creada con éxito');
                  } catch (e) {
                    print("Error al crear sugerencia: $e");
                    _showSnackBar('Error al crear sugerencia');
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

  void _navigateToMisSugerencias() async {
    String? userIdString = await _secureStorageService.obtenerUserId();
    int userId = int.tryParse(userIdString ?? '') ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MisSugerenciasPage(userId: userId),
      ),
    );
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sugerencias',
            style: TextStyle(
              color: Colors.white,
            ),
        ),
        backgroundColor: const Color.fromARGB(255, 75, 96, 112),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _showCreateSugerenciaDialog,       
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: _navigateToMisSugerencias,
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

class MisSugerenciasPage extends StatelessWidget {
  final int userId;
  final ApiService apiService = ApiService(Dio());

  MisSugerenciasPage({required this.userId});

  Future<List<Sugerencia>> fetchMisSugerencias() async {
    try {
      return await apiService.obtenerSugerenciasPorUsuario(userId);
    } catch (e) {
      print("Error al obtener mis sugerencias: $e");
      return [];
    }
  }

  void _showEditSugerenciaDialog(BuildContext context, int sugerenciaId, String sugerenciaActual) {
    final TextEditingController sugerenciaController = TextEditingController(text: sugerenciaActual);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Sugerencia'),
          content: TextField(
            controller: sugerenciaController,
            decoration: InputDecoration(hintText: 'Edita tu sugerencia aquí'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (sugerenciaController.text.isNotEmpty) {
                  try {
                    final sugerenciaData = {
                      'sugerencia': sugerenciaController.text,
                    };
                    await apiService.editarSugerenciaPorId(sugerenciaId, sugerenciaData);
                    Navigator.of(context).pop(); // Cerrar diálogo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sugerencia actualizada con éxito.')),
                    );
                  } catch (e) {
                    print('Error al actualizar sugerencia: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al actualizar la sugerencia.')),
                    );
                  }
                }
              },
              child: Text('Guardar'),
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
        title: Text('Mis Sugerencias',
            style: TextStyle(
              color: Colors.white,
            ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<List<Sugerencia>>(
        future: fetchMisSugerencias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar sugerencias'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No tienes sugerencias.'));
          } else {
            final sugerencias = snapshot.data!;
            return ListView.builder(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: () => _showEditSugerenciaDialog(
                                context,
                                sugerencia.idSugerencia,
                                sugerencia.sugerencia,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
