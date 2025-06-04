import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/services/api_service.dart';
import 'package:restaurante_potosi_app/services/secure_storage_service.dart';
import 'package:restaurante_potosi_app/model/modelCuponResponse.dart';
import 'package:intl/intl.dart';


class CuponesPage extends StatefulWidget {
  @override
  _CuponesPageState createState() => _CuponesPageState();
}

class _CuponesPageState extends State<CuponesPage> {
  late ApiService apiService;
  late SecureStorageService _secureStorageService;
  List<Cupon> cupones = [];
  bool isLoading = true;
  final formato = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    _secureStorageService = SecureStorageService();
    fetchCupones();
  }

  Future<void> fetchCupones() async {
    try {
      String? userIdString = await _secureStorageService.obtenerUserId();

      // Validación de userIdString antes de convertirlo a int
      if (userIdString != null && userIdString.isNotEmpty) {
        int? userId = int.tryParse(userIdString);

        if (userId != null) { // Solo continúa si userId es válido
          final fetchedCupones = await apiService.getCuponesPorUsuario(userId);

          // Verificamos si el widget sigue montado antes de llamar a setState
          if (mounted) {
            setState(() {
              cupones = fetchedCupones;
              isLoading = false;
            });
          }
        } else {
          // Manejamos el caso donde userId es null
          if (mounted) {
            setState(() => isLoading = false);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ID de usuario no válido')),
          );
        }
      } else {
        // Manejamos el caso donde userIdString es null o vacío
        if (mounted) {
          setState(() => isLoading = false);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró un ID de usuario')),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      print("Error al obtener cupones: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los cupones')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Cupones",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor:  Color.fromARGB(255, 75, 96, 112),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cupones.isEmpty
              ? Center(child: Text("No tienes cupones disponibles."))
              : ListView.builder(
                  itemCount: cupones.length,
                  itemBuilder: (context, index) {
                    final cupon = cupones[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text("Cupón: ${cupon.cupon}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Descuento: ${cupon.porcentajeDescuento}%"),
                            Text("Usos disponibles: ${cupon.usosDisponibles} de ${cupon.usosMaximos}"),
                            Text(
                              'Expira: ${cupon.fechaExpiracion != null ? formato.format(cupon.fechaExpiracion!) : 'Sin fecha'}',
                            ),
                          ],
                        ),
                        trailing: cupon.estado
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.cancel, color: Colors.red),
                      ),
                    );
                  },
                ),
    );
  }
}
