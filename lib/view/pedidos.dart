import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/model/modelPedidosUsuario.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/services/secure_storage_service.dart';

class PantallaPedidosUsuario extends StatefulWidget {
  @override
  _PantallaPedidosUsuarioState createState() => _PantallaPedidosUsuarioState();
}

class _PantallaPedidosUsuarioState extends State<PantallaPedidosUsuario> {
  late ApiService apiService;
  late SecureStorageService _secureStorageService;

  List<PedidosUsuario> _pedidos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(contentType: "application/json"));
    apiService = ApiService(dio);
    _secureStorageService = SecureStorageService();
    _obtenerPedidos();
  }

  Future<void> _obtenerPedidos() async {
    try {
      String? userIdString = await _secureStorageService.obtenerUserId();
      int userId = int.tryParse(userIdString ?? '') ?? 0;

      final pedidos = await apiService.getPedidosPorUsuario(userId);
      setState(() {
        _pedidos = pedidos;
        _loading = false;
      });
    } catch (e) {
      print('Error al obtener los pedidos: $e');
      setState(() {
        _loading = false;
      });
      // Manejar el error (por ejemplo, mostrar un mensaje al usuario)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Pedidos"),
        backgroundColor: Colors.red,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? Center(child: Text("No has realizado ningún pedido."))
              : ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = _pedidos[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          "Pedido #${pedido.idPedido}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Estado: ${pedido.estadoPedido}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            Text(
                              "Fecha: ${pedido.fechaPedido.toLocal().toString().split(' ')[0]}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            Text(
                              "Total: Bs. ${pedido.total}",
                              style: TextStyle(fontSize: 14, color: Colors.green),
                            ),
                          ],
                        ),
                        children: pedido.detalles.map((detalle) {
                          return ListTile(
                            title: Text(
                              detalle.nombreProducto,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Cantidad: ${detalle.cantidad} \nSubtotal: Bs. ${detalle.subtotal} \nPrecio Unitario: Bs. ${detalle.precioUnitario}",
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
    );
  }
}
