import 'package:restaurante_potosi_app/model/modelMenuResponse.dart';
import 'package:restaurante_potosi_app/model/modelProductoResponse.dart';
import 'package:restaurante_potosi_app/model/modelPedidoRequest.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';


@RestApi(baseUrl: 'http://10.0.2.2:8000/')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;
  //Obtener productos
  @GET('products/menu/menus/')
  Future<List<MenuWithProducts>> getMenus();

  @GET('products/productos/{id}')
  Future<Producto> getProducto(@Path("id") int id);

  @POST('/orders/pedidos/')
  Future<Pedido> crearPedido(@Body() Pedido pedido);
}