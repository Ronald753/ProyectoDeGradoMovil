import 'package:restaurante_potosi_app/model/modelMenuResponse.dart';
import 'package:restaurante_potosi_app/model/modelPedidosUsuario.dart';
import 'package:restaurante_potosi_app/model/modelProductoResponse.dart';
import 'package:restaurante_potosi_app/model/modelPedidoRequest.dart';
import 'package:restaurante_potosi_app/model/modelLoginResponse.dart';
import 'package:restaurante_potosi_app/model/modelUsuarioRequest.dart';
import 'package:restaurante_potosi_app/model/modelObtenerValoraciones.dart';
import 'package:restaurante_potosi_app/model/modelValoracionRequest.dart';
import 'package:restaurante_potosi_app/model/modelUsuarioResponse.dart';
import 'package:restaurante_potosi_app/model/modelCreateUsuarioResponse.dart';
import 'package:restaurante_potosi_app/model/modelObtenerSugerenciasResponse.dart';
import 'package:restaurante_potosi_app/model/modelCrearSugerenciaRequest.dart';
import 'package:restaurante_potosi_app/model/modelCuponResponse.dart'; // Importa el modelo de cupon
import 'package:restaurante_potosi_app/model/modelCampanaResponse.dart'; 
import 'package:restaurante_potosi_app/model/modelSugerenciasUsuarioResponse.dart'; 
import 'package:restaurante_potosi_app/model/modelEditarPerfilResponse.dart'; 
import 'package:restaurante_potosi_app/model/modelCuponUseResponse.dart'; 
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';


@RestApi(baseUrl: 'https://proyectoapidjango.up.railway.app/')
//@RestApi(baseUrl: 'http://192.168.0.18:8000/')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET('orders/cupones/buscar_cupon/{cupon_codigo}/')
  Future<CuponResponse> buscarCupon(@Path("cupon_codigo") String cuponCodigo);

  //Obtener productos
  @GET('products/menu/menus/')
  Future<List<MenuWithProducts>> getMenus();

  @GET('products/productos/{id}')
  Future<Producto> getProducto(@Path("id") int id);

  @POST('orders/pedidos/')
  Future<Pedido> crearPedido(@Body() Pedido pedido);
  
  @GET('orders/pedidos/usuario/{id_usuario}/')
  Future<List<PedidosUsuario>> getPedidosPorUsuario(@Path("id_usuario") int idUsuario);

  @POST('clients/usuarios/login/')
  Future<LoginResponse> login(@Body() Map<String, dynamic> loginRequest);

  @POST("clients/usuarios/add/")
  Future<UsuarioResponse> createUser(@Body() UsuarioRequest user);

  @GET('clients/usuarios/{id}/')
  Future<Usuario> getUsuarioPorId(@Path("id") int id);

  @PUT('clients/usuarios/update/{id_usuario}/')
  Future<EditarUsuarioResponse> actualizarUsuario(
    @Path("id_usuario") int idUsuario,
    @Body() Map<String, dynamic> usuarioData,
  );

  @GET('products/valoraciones/producto/{idProducto}/')
  Future<List<ValoracionProducto>> getValoracionesPorProducto(
    @Path("idProducto") int idProducto,
  );

  // Crear una nueva valoración
  @POST('products/valoraciones/valorar/')
  Future<void> enviarValoracion(@Body() ValoracionProductoRequest valoracion);

  // Obtener sugerencias activas
  @GET('clients/sugerencias/actives/') // Asegúrate de que esta URL sea correcta según tu configuración de API
  Future<List<ObtenerSugerencias>> obtenerSugerenciasActivas();

  @GET('clients/sugerencias/usuario/{id_usuario}/')
  Future<List<Sugerencia>> obtenerSugerenciasPorUsuario(@Path("id_usuario") int idUsuario);

  @POST('clients/sugerencias/add/')
  Future<void> crearSugerencia(@Body() CrearSugerencia sugerencia); // Método para crear sugerencia

  @PATCH('clients/sugerencias/editar_por_id/{sugerencia_id}/')
  Future<Sugerencia> editarSugerenciaPorId(
    @Path("sugerencia_id") int sugerenciaId,
    @Body() Map<String, dynamic> sugerenciaData,
  );

  // Obtener cupones asignados a un usuario específico
  @GET('orders/cupones/usuario/{id_usuario}/')
  Future<List<Cupon>> getCuponesPorUsuario(@Path("id_usuario") int idUsuario);

  @GET('orders/campanas/listar/')
  Future<List<Campaign>> getCampanasActivas();
}