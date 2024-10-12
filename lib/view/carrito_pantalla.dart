import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante_potosi_app/model/Carrito.dart';
import 'package:restaurante_potosi_app/model/modelPedidoRequest.dart'; // Asegúrate de importar tu modelo de pedido
import 'package:restaurante_potosi_app/services/api_service.dart'; // Asegúrate de importar tu servicio API
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/view/menu.dart'; // Importa Dio

class PantallaCarrito extends StatefulWidget {
  @override
  _PantallaCarritoState createState() => _PantallaCarritoState();
}

class _PantallaCarritoState extends State<PantallaCarrito> {
  late ApiService apiService;
  String tipoPedido = "Para comer aquí"; // Inicializamos el tipo de pedido
  DateTime fechaPedido = DateTime.now(); // Fecha actual

  @override
  void initState() {
    super.initState();
    // Inicializa el servicio API aquí
    final dio = Dio();
    apiService = ApiService(dio);
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
                    // Selección del tipo de pedido
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
                            Image.asset(
                              'assets/img/hamburguesa.jpg',
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
              // Construir el pedido
              var detalles = carrito.items.values.map((item) {
                return DetallePedido(
                  id_producto: int.parse(item.id),
                  cantidad: item.cantidad,
                  precio_unitario: item.precio,
                  subtotal: item.precio * item.cantidad,
                );
              }).toList();

              var nuevoPedido = Pedido(
                id_usuario: 1, // Cambia esto según tu lógica de usuario
                fecha_pedido: fechaPedido.toIso8601String(), // Usar la fecha actual
                tipo_pedido: tipoPedido, // Usar el tipo de pedido seleccionado
                id_cupon: null, // O el ID del cupón si lo tienes
                total: carrito.montoTotal,
                detalles: detalles,
              );

              // Enviar el pedido a la API
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
      // Navegar a la pantalla del menú después de enviar el pedido
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaMenu(),
        ),
      ); // Cambia esto al nombre correcto de tu ruta
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
