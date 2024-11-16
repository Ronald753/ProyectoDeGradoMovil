import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurante_potosi_app/services/api_service.dart'; // Asegúrate de importar tu ApiService
import 'package:restaurante_potosi_app/model/modelCampanaResponse.dart'; 

class CampanasActivasPage extends StatefulWidget {
  @override
  _CampanasActivasPageState createState() => _CampanasActivasPageState();
}

class _CampanasActivasPageState extends State<CampanasActivasPage> {
  late ApiService apiService;
  List<Campaign> campanas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    _fetchCampanasActivas();
  }

  Future<void> _fetchCampanasActivas() async {
    try {
      final fetchedCampanas = await apiService.getCampanasActivas();
      setState(() {
        campanas = fetchedCampanas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar campañas activas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campañas Activas'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : campanas.isEmpty
              ? Center(
                  child: Text(
                    'No hay campañas activas.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: campanas.length,
                  itemBuilder: (context, index) {
                    final campaign = campanas[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              campaign.titulo,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(campaign.mensaje),
                            SizedBox(height: 5),
                            Text(
                              'Tipo: ${campaign.tipoPromocion}',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Descuento: ${campaign.descuento}%',
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Válido desde: ${campaign.fechaInicio} hasta ${campaign.fechaFin}',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 10),
                            if (campaign.productosRelacionados.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Productos Relacionados:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ...campaign.productosRelacionados.map(
                                    (producto) => Text(
                                      '- $producto',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
