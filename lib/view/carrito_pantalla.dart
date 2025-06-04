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
          backgroundColor: const Color.fromARGB(255, 75, 96, 112),
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
                    // Visualización de los productos en el carrito
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
              // Preguntar si tiene un cupón
              _preguntarSiTieneCupon(carrito);
            }
          },
          backgroundColor: Colors.blueGrey,
          child: Icon(
            Icons.send,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  Future<void> _preguntarSiTieneCupon(Carrito carrito) async {
    // Mostrar un cuadro de diálogo para preguntar si tiene un cupón
    bool tieneCupon = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¿Tienes un cupón?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);  // Usuario tiene cupón
            },
            child: Text("Sí"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);  // Usuario no tiene cupón
            },
            child: Text("No"),
          ),
        ],
      ),
    );

    if (tieneCupon) {
      // Si tiene cupón, preguntar el código del cupón
      String cuponCodigo = await _mostrarInputCupon();
      
      if (cuponCodigo.isNotEmpty) {
        // Llamar a la API para buscar el cupon
        await _buscarCupon(cuponCodigo, carrito);
      } else {
        // Si no se ingresa un cupón, enviar el pedido sin id_cupon
        _enviarPedidoSinCupon(carrito);
      }
    } else {
      // Si no tiene cupón, enviar el pedido sin id_cupon
      _enviarPedidoSinCupon(carrito);
    }
  }

  Future<String> _mostrarInputCupon() async {
    String cuponCodigo = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ingresa el código de tu cupón"),
        content: TextField(
          onChanged: (value) {
            cuponCodigo = value;
          },
          decoration: InputDecoration(hintText: "Código de cupón"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Aceptar"),
          ),
        ],
      ),
    );
    return cuponCodigo;
  }

  Future<void> _buscarCupon(String cuponCodigo, Carrito carrito) async {
    try {
      final cuponResponse = await apiService.buscarCupon(cuponCodigo);
      
      if (cuponResponse.error!.isEmpty) {
        // Si el cupon es válido, agregar el id_cupon al pedido
        _enviarPedidoConCupon(cuponResponse.idCupon ?? 0, carrito);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cuponResponse.error ?? "")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al verificar el cupón: $e")),
      );
      _enviarPedidoSinCupon(carrito);
    }
  }

  void _enviarPedidoConCupon(int idCupon, Carrito carrito) {
    var detalles = carrito.items.values.map((item) {
      return DetallePedido(
        id_producto: int.parse(item.id),
        cantidad: item.cantidad,
        precio_unitario: item.precio,
        subtotal: item.precio * item.cantidad,
      );
    }).toList();

    var nuevoPedido = Pedido(
      id_usuario: userId ?? 0,
      fecha_pedido: fechaPedido.toIso8601String(),
      tipo_pedido: tipoPedido,
      id_cupon: idCupon,
      total: carrito.montoTotal,
      detalles: detalles,
    );

    enviarPedido(nuevoPedido);
    carrito.removeCarrito();
  }

  void _enviarPedidoSinCupon(Carrito carrito) {
    var detalles = carrito.items.values.map((item) {
      return DetallePedido(
        id_producto: int.parse(item.id),
        cantidad: item.cantidad,
        precio_unitario: item.precio,
        subtotal: item.precio * item.cantidad,
      );
    }).toList();

    var nuevoPedido = Pedido(
      id_usuario: userId ?? 0,
      fecha_pedido: fechaPedido.toIso8601String(),
      tipo_pedido: tipoPedido,
      id_cupon: null, // No hay cupón
      total: carrito.montoTotal,
      detalles: detalles,
    );

    enviarPedido(nuevoPedido);
    carrito.removeCarrito();
  }

  Future<void> enviarPedido(Pedido pedido) async {
    try {
      print(pedido.toString());
      final response = await apiService.crearPedido(pedido);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido enviado con éxito'),
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
