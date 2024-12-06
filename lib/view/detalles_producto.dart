import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/model/modelProductoResponse.dart'; // Asegúrate de importar el modelo
import 'package:provider/provider.dart';
import 'package:restaurante_potosi_app/model/Carrito.dart'; // Importa el modelo de carrito
import 'package:restaurante_potosi_app/view/carrito_pantalla.dart';
import 'package:restaurante_potosi_app/view/valoraciones_producto.dart'; // Nueva pantalla para valoraciones
import 'package:restaurante_potosi_app/services/secure_storage_service.dart';

class PantallaDescripcionProducto extends StatefulWidget {
  final int idProducto;

  const PantallaDescripcionProducto({Key? key, required this.idProducto}) : super(key: key);

  @override
  _PantallaDescripcionProducto createState() => _PantallaDescripcionProducto();
}

class _PantallaDescripcionProducto extends State<PantallaDescripcionProducto> {
  late Future<Producto> _productoFuture;
  late ApiService apiService;

  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(contentType: "application/json"));
    apiService = ApiService(dio);

    // Llama a la API para obtener el producto
    _productoFuture = apiService.getProducto(widget.idProducto);

    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    String? userIdString = await _secureStorageService.obtenerUserId();
    int userId = int.tryParse(userIdString ?? '') ?? 0;

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
          title: Text("Descripción del Producto",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor:  Color.fromARGB(255, 75, 96, 112),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 30,
                  color: Colors.white,
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
                      color: Colors.grey,
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar imagen del producto
                  if (producto.imagenUrl != null && producto.imagenUrl!.isNotEmpty)
                    Center(
                      child: Image.network(
                        producto.imagenUrl!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Center(
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 100, color: Colors.grey),
                      ),
                    ),
                  SizedBox(height: 16),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        agregarAlCarrito(context, producto);
                      },
                      child: Text("Añadir al carrito",
                      style: TextStyle(
                        color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey, // Color de fondo
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12), // Padding
                        textStyle: TextStyle(fontSize: 18), // Estilo del texto
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PantallaValoracionesProducto(idProducto: widget.idProducto),
                          ),
                        );
                      },
                      child: Text("Ver valoraciones",
                      style: TextStyle(
                        color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey, 
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
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
      producto.imagenUrl ?? "Imagen no encontrada",
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
