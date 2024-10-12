import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/model/modelProductoResponse.dart'; // Asegúrate de importar el modelo
import 'package:provider/provider.dart';
import 'package:restaurante_potosi_app/model/Carrito.dart'; // Asegúrate de importar el modelo de carrito
import 'package:restaurante_potosi_app/view/carrito_pantalla.dart';

class PantallaDescripcionProducto extends StatefulWidget {
  final int idProducto; // Recibimos el id_producto

  const PantallaDescripcionProducto({Key? key, required this.idProducto}) : super(key: key);

  @override
  _PantallaDescripcionProducto createState() => _PantallaDescripcionProducto();
}

class _PantallaDescripcionProducto extends State<PantallaDescripcionProducto> {
  late Future<Producto> _productoFuture; // Variable para almacenar el futuro del producto

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(contentType: "application/json"));
    final apiService = ApiService(dio);

    // Llama a la API para obtener el producto
    _productoFuture = apiService.getProducto(widget.idProducto);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Carrito>(builder: (context, carrito, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Descripción del Producto"),
          actions: <Widget>[
            new Stack(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.shopping_cart),
                    iconSize: 30,
                    color: Colors.black,
                    onPressed: () {
                      accederCarrito(context, carrito);
                    }),
                new Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4)),
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
                  // Nombre del producto
                  Text(
                    producto.nombreProducto,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  
                  // Descripción del producto
                  Text(
                    producto.descripcion,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),

                  // Precio del producto
                  Text(
                    'Precio: Bs. ${producto.precio != null ? producto.precio!.toStringAsFixed(2) : 'No disponible'}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 16),

                  // Título de Ingredientes
                  Text(
                    'Ingredientes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  
                  // Lista de ingredientes
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

                  // Botón "Añadir al carrito"
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
                ],
              ),
            );
          },
        ),
      );
    });
  }

  void agregarAlCarrito(BuildContext context, Producto producto) {
    final carrito = Provider.of<Carrito>(context, listen: false); // Obtén el carrito del contexto

    // Agrega el producto al carrito
    carrito.agregarItem(
      producto.idProducto.toString(), // Asumiendo que tu modelo Producto tiene un id
      producto.nombreProducto,
      producto.precio ?? 0.0,
      "1", // Cantidad, puedes modificar esto si deseas
      1, // Este es el valor que estás usando en tu ejemplo original, puedes ajustarlo según sea necesario
    );

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${producto.nombreProducto} agregado al carrito')),
    );
  }

  void accederCarrito(
      BuildContext context, Carrito carrito) async {
      print("Verificando sesión y accediendo al carrito...");
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
