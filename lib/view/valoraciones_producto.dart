import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/model/modelObtenerValoraciones.dart'; // Modelo de valoraciones
import 'package:restaurante_potosi_app/model/modelValoracionRequest.dart'; // Modelo de solicitud de valoración
import 'package:restaurante_potosi_app/services/api_service.dart'; // Servicio de API
import 'package:restaurante_potosi_app/services/secure_storage_service.dart'; // Servicio de almacenamiento seguro

class PantallaValoracionesProducto extends StatefulWidget {
  final int idProducto;

  const PantallaValoracionesProducto({Key? key, required this.idProducto}) : super(key: key);

  @override
  _PantallaValoracionesProductoState createState() => _PantallaValoracionesProductoState();
}

class _PantallaValoracionesProductoState extends State<PantallaValoracionesProducto> {
  late ApiService apiService;
  late Future<List<ValoracionProducto>> _valoracionesFuture;
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(contentType: "application/json"));
    apiService = ApiService(dio);
    _valoracionesFuture = apiService.getValoracionesPorProducto(widget.idProducto);
  }

  void _recargarValoraciones() {
    setState(() {
      _valoracionesFuture = apiService.getValoracionesPorProducto(widget.idProducto);
    });
  }

  void _mostrarDialogoValoracion(BuildContext context) {
    final TextEditingController _comentarioController = TextEditingController();
    int _valoracionSeleccionada = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Valorar Producto"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _valoracionSeleccionada ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            _valoracionSeleccionada = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: _comentarioController,
                    decoration: InputDecoration(hintText: "Escribe un comentario"),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                String? userIdString = await _secureStorageService.obtenerUserId();
                int userId = int.tryParse(userIdString ?? '') ?? 0;

                final valoracionRequest = ValoracionProductoRequest(
                  idProducto: widget.idProducto,
                  idUsuario: userId,
                  valoracion: _valoracionSeleccionada,
                  comentario: _comentarioController.text,
                );

                try {
                  await apiService.enviarValoracion(valoracionRequest);
                  Navigator.of(context).pop(); // Cierra el diálogo
                  _recargarValoraciones(); // Recarga valoraciones
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Valoración enviada con éxito")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al enviar la valoración: $e")),
                  );
                }
              },
              child: Text("Enviar"),
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
        title: Text("Valoraciones del Producto"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.rate_review),
            onPressed: () {
              _mostrarDialogoValoracion(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ValoracionProducto>>(
        future: _valoracionesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error al cargar valoraciones: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No hay valoraciones para este producto."),
            );
          }

          final valoraciones = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: valoraciones.length,
            itemBuilder: (context, index) {
              final valoracion = valoraciones[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8), // Margen entre tarjetas
                elevation: 4, // Sombra de las tarjetas
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 30), // Icono de estrella
                          SizedBox(width: 8),
                          Text(
                            "${valoracion.valoracion} / 5",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        valoracion.comentario,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Usuario: ${valoracion.nombreUsuario} ${valoracion.apellidoUsuario}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Fecha: ${valoracion.getFormattedFechaValoracion()}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
