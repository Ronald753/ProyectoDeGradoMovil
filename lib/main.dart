import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante_potosi_app/view/menu.dart';
import 'package:restaurante_potosi_app/model/Carrito.dart';
import 'package:restaurante_potosi_app/view/login.dart';
import 'package:restaurante_potosi_app/view/inicio_botones.dart';



void main() => runApp(ChangeNotifierProvider(
      create: (context) => Carrito(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PantallaInicioBotones()
    );
  }
}
