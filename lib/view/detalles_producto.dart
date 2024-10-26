import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/model/modelProductoResponse.dart'; // Asegúrate de importar el modelo
import 'package:restaurante_potosi_app/model/modelObtenerValoraciones.dart'; // Importa el modelo de ValoracionProducto
import 'package:provider/provider.dart';
import 'package:restaurante_potosi_app/model/Carrito.dart'; // Importa el modelo de carrito
import 'package:restaurante_potosi_app/view/carrito_pantalla.dart';
import 'package:restaurante_potosi_app/model/modelValoracionRequest.dart'; // Importa el modelo de valoración
import 'package:restaurante_potosi_app/services/secure_storage_service.dart';
import 'package:validators/sanitizers.dart';

class PantallaDescripcionProducto extends StatefulWidget {
  final int idProducto;

  const PantallaDescripcionProducto({Key? key, required this.idProducto}) : super(key: key);

  @override
  _PantallaDescripcionProducto createState() => _PantallaDescripcionProducto();
}

class _PantallaDescripcionProducto extends State<PantallaDescripcionProducto> {
  late Future<Producto> _productoFuture;
  late Future<List<ValoracionProducto>> _valoracionesFuture;
  late ApiService apiService;

  void _recargarValoraciones() {
    setState(() {
      _valoracionesFuture = apiService.getValoracionesPorProducto(widget.idProducto);
    });
  }

  void _mostrarDialogoValoracion(BuildContext context) {
    final _comentarioController = TextEditingController();
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
                    decoration: InputDecoration(hintText: "Comentario"),
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
                // Obtener el userId aquí
                String? userIdString = await _secureStorageService.obtenerUserId();
                int userId = int.tryParse(userIdString ?? '') ?? 0; // Conversión a int

                final valoracionRequest = ValoracionProductoRequest(
                  idProducto: widget.idProducto,
                  idUsuario: userId, // Usa el userId obtenido
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


  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(contentType: "application/json"));
    apiService = ApiService(dio);

    // Llama a la API para obtener el producto y las valoraciones
    _productoFuture = apiService.getProducto(widget.idProducto);
    _valoracionesFuture = apiService.getValoracionesPorProducto(widget.idProducto);

    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    String? userIdString = await _secureStorageService.obtenerUserId();
    int userId = int.tryParse(userIdString ?? '') ?? 0; // Conversión a int

    String? token = await _secureStorageService.obtenerToken();

    // Ahora puedes usar userId y token según lo necesites
    print('User ID: $userId');
    print('Token: $token');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Carrito>(builder: (context, carrito, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Descripción del Producto"),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {
                    accederCarrito(context, carrito);
                  },
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    constraints: BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      carrito.numeroProductos.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        body: FutureBuilder<Producto>(
          future: _productoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("Error al cargar el producto: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("Producto no encontrado"));
            }

            final producto = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombreProducto,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    producto.descripcion,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Precio: Bs. ${producto.precio != null ? producto.precio!.toStringAsFixed(2) : 'No disponible'}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ingredientes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: producto.ingredientes.length,
                      itemBuilder: (context, index) {
                        final ingrediente = producto.ingredientes[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ingrediente.nombreIngrediente,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  ingrediente.descripcionIngrediente,
                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        agregarAlCarrito(context, producto);
                      },
                      child: Text("Añadir al carrito"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _mostrarDialogoValoracion(context);
                      },
                      child: Text("Valorar producto"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Apartado de comentarios
                  Text(
                    'Comentarios:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder<List<ValoracionProducto>>(
                    future: _valoracionesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error al cargar valoraciones"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No hay valoraciones para este producto"));
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final valoracion = snapshot.data![index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Espacio entre tarjetas
                              elevation: 4, // Sombra de la tarjeta
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                              ),
                              child: ListTile(
                                leading: Icon(Icons.star, color: Colors.amber, size: 30), // Tamaño del icono
                                title: Text(
                                  "Valoración: ${valoracion.valoracion}",
                                  style: TextStyle(fontWeight: FontWeight.bold), // Estilo en negrita
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      valoracion.comentario,
                                      style: TextStyle(fontSize: 14), // Tamaño de texto del comentario
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Fecha y hora: ${valoracion.getFormattedFechaValoracion()}",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Usuario: ${valoracion.nombreUsuario} ${valoracion.apellidoUsuario}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  void agregarAlCarrito(BuildContext context, Producto producto) {
    final carrito = Provider.of<Carrito>(context, listen: false);

    carrito.agregarItem(
      producto.idProducto.toString(),
      producto.nombreProducto,
      producto.precio ?? 0.0,
      "1",
      1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${producto.nombreProducto} agregado al carrito')),
    );
  }

  void accederCarrito(BuildContext context, Carrito carrito) async {
    if (carrito.numeroProductos == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Agrega un producto"),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext) => PantallaCarrito(),
        ),
      );
    }
  }
}
