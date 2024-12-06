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
            "Menú",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 75, 96, 112),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white, // Color del texto seleccionado
            unselectedLabelColor: Colors.grey, // Color del texto no seleccionado
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: 20), // Tamaño de la fuente del texto seleccionado
            unselectedLabelStyle: TextStyle(fontSize: 16), // Tamaño de la fuente del texto no seleccionado
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
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return GestureDetector(
                    onTap: () {
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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Imagen del producto
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: producto.imagenUrl != null && producto.imagenUrl.isNotEmpty
                                ? Image.network(
                                    producto.imagenUrl,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 100,
                                    width: double.infinity,
                                    color: Colors.grey,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            producto.nombreProducto ?? 'Nombre no disponible',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bs. ${producto.precioProducto.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
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
