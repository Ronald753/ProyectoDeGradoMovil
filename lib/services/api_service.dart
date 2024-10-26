import 'package:restaurante_potosi_app/model/modelMenuResponse.dart';
import 'package:restaurante_potosi_app/model/modelProductoResponse.dart';
import 'package:restaurante_potosi_app/model/modelPedidoRequest.dart';
import 'package:restaurante_potosi_app/model/modelLoginResponse.dart';
import 'package:restaurante_potosi_app/model/modelUsuarioRequest.dart';
import 'package:restaurante_potosi_app/model/modelObtenerValoraciones.dart';
import 'package:restaurante_potosi_app/model/modelValoracionRequest.dart';
import 'package:restaurante_potosi_app/model/modelUsuarioResponse.dart';
import 'package:restaurante_potosi_app/model/modelCreateUsuarioResponse.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';


@RestApi(baseUrl: 'http://192.168.0.20:8000/')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;
  //Obtener productos
  @GET('products/menu/menus/')
  Future<List<MenuWithProducts>> getMenus();

  @GET('products/productos/{id}')
  Future<Producto> getProducto(@Path("id") int id);

  @POST('orders/pedidos/')
  Future<Pedido> crearPedido(@Body() Pedido pedido);

  @POST('clients/usuarios/login/')
  Future<LoginResponse> login(@Body() Map<String, dynamic> loginRequest);

  @POST("clients/usuarios/add/")
  Future<UsuarioResponse> createUser(@Body() UsuarioRequest user);

  @GET('clients/usuarios/{id}/')
  Future<Usuario> getUsuarioPorId(@Path("id") int id);

  @GET('products/valoraciones/producto/{idProducto}/')
  Future<List<ValoracionProducto>> getValoracionesPorProducto(
    @Path("idProducto") int idProducto,
  );

  // Crear una nueva valoración
  @POST('products/valoraciones/valorar/')
  Future<void> enviarValoracion(@Body() ValoracionProductoRequest valoracion);
}