import 'package:flutter/material.dart';
import 'vista/home_vista.dart';
import '../modelo/usuarios_modelo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EspeBandidos Bank',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        scaffoldBackgroundColor: Color(0xFFF4F7F9),
        fontFamily: 'Roboto',
      ),
      home: HomeVista(
        usuario: UsuarioModelo(
          nombre: "Bandido1",
          contrasena: "1234",
          saldo: 2150.0,
        ),
      ),
    );
  }
}
