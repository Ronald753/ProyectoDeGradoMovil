import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante_potosi_app/model/Carrito.dart';
import 'package:restaurante_potosi_app/model/modelPedidoRequest.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/view/inicio_botones.dart';
import 'package:restaurante_potosi_app/services/secure_storage_service.dart';

class PantallaCarrito extends StatefulWidget {
  @override
  _PantallaCarritoState createState() => _PantallaCarritoState();
}

class _PantallaCarritoState extends State<PantallaCarrito> {
  late ApiService apiService;
  String tipoPedido = "Para comer aquí";
  DateTime fechaPedido = DateTime.now();
  final SecureStorageService _secureStorageService = SecureStorageService();
  int? userId; // Declara userId como una variable de estado opcional

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    apiService = ApiService(dio);
    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    String? userIdString = await _secureStorageService.obtenerUserId();
    setState(() {
      userId = int.tryParse(userIdString ?? '') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Carrito>(builder: (context, carrito, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pedidos",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: carrito.items.isEmpty
              ? Center(
                  child: Text("Carrito vacío"),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tipo de Pedido:"),
                          DropdownButton<String>(
                            value: tipoPedido,
                            onChanged: (String? newValue) {
                              setState(() {
                                tipoPedido = newValue!;
                              });
                            },
                            items: <String>['Para comer aquí', 'Para llevar']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    for (var item in carrito.items.values)
                      Card(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Image.network(
                                    item.imagen,
                                    width: 100,
                                  ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(item.nombre),
                                    Text("Bs " +
                                        item.precio.toString() +
                                        " x " +
                                        item.unidad),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _buildIconButton(
                                          icon: Icons.remove,
                                          onPressed: () {
                                            setState(() {
                                              carrito.decrementarCantidadItem(item.id);
                                            });
                                          },
                                        ),
                                        SizedBox(width: 20, child: Center(child: Text(item.cantidad.toString()))),
                                        _buildIconButton(
                                          icon: Icons.add,
                                          onPressed: () {
                                            setState(() {
                                              carrito.incrementarCantidadItem(item.id);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 70,
                              decoration: BoxDecoration(color: Color(0x99f0f0f0)),
                              child: Center(
                                child: Text("Bs " +
                                    (item.precio * item.cantidad).toString()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Text("Total: " +
                              "Bs " +
                              carrito.montoTotal.toString()),
                        ],
                      ),
                    )
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (carrito.numeroProductos == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'El carrito está vacío. Agrega productos antes de enviar el pedido.'),
                ),
              );
            } else {
              var detalles = carrito.items.values.map((item) {
                return DetallePedido(
                  id_producto: int.parse(item.id),
                  cantidad: item.cantidad,
                  precio_unitario: item.precio,
                  subtotal: item.precio * item.cantidad,
                );
              }).toList();
              
              // Asegúrate de que userId tenga un valor antes de crear el pedido
              var nuevoPedido = Pedido(
                id_usuario: userId ?? 0, // Asigna userId recuperado
                fecha_pedido: fechaPedido.toIso8601String(),
                tipo_pedido: tipoPedido,
                id_cupon: null,
                total: carrito.montoTotal,
                detalles: detalles,
              );

              enviarPedido(nuevoPedido);
              carrito.removeCarrito();
            }
          },
          backgroundColor: Colors.red,
          child: Icon(
            Icons.send,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  Future<void> enviarPedido(Pedido pedido) async {
    try {
      print(pedido.toString());
      final response = await apiService.crearPedido(pedido);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido enviado con éxito: ${response.toJson()}'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaInicioBotones(),
        ),
      );
    } catch (e) {
      print('Error al enviar el pedido: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar el pedido: $e'),
        ),
      );
    }
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      child: IconButton(
        icon: Icon(
          icon,
          size: 13,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
      width: 50,
      height: 30,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(30))),
    );
  }
}
