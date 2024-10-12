import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/model/modelMenuResponse.dart';
import 'package:restaurante_potosi_app/services/api_service.dart'; // Importa tu ApiService
import 'package:restaurante_potosi_app/view/detalles_producto.dart';

class PantallaMenu extends StatelessWidget {
  const PantallaMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  FutureBuilder _body(BuildContext context) {
    final dio = Dio(BaseOptions(contentType: "application/json"));
    final apiService = ApiService(dio);

    return FutureBuilder(
      future: apiService.getMenus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<MenuWithProducts> menus = snapshot.data!;
          return _menuTabView(menus, context);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _menuTabView(List<MenuWithProducts> menus, BuildContext context) {
    return DefaultTabController(
      length: menus.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Menú", // Título de la pantalla
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            // Aquí se cambió el texto a tipo de menú
            tabs: menus.map((menu) => Tab(child: Text(menu.menu.tipoMenu))).toList(),
          ),
        ),
        body: TabBarView(
          children: menus.map((menu) {
            final productos = menu.productos;
            return Container(
              padding: EdgeInsets.all(5),
              child: GridView.builder(
                itemCount: productos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return GestureDetector(
                    onTap: () {
                      // Aquí puedes agregar la navegación a detalles si es necesario
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PantallaDescripcionProducto(idProducto: producto.idProducto),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          // Imagen placeholder por ahora
                          Container(
                            height: 90,
                            color: Colors.black12,
                            width: double.infinity,
                          ),
                          Text(
                            producto.nombreProducto ?? 'Nombre no disponible',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Aquí se agregó el precio de producto
                          Text(
                            'Bs. ${producto.precioProducto.toString()}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
