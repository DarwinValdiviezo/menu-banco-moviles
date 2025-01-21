import 'package:flutter/material.dart';

class Estilo {
  static const Color verdePrimario = Color(0xFF4CAF50);
  static const Color verdeOscuro = Color(0xFF087F23);
  static const Color verdeClaro = Color(0xFFA5D6A7);
  static const Color fondo = Color(0xFFF4F7F9);

  static const TextStyle tituloAppBar = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle tituloPantalla = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: verdeOscuro,
  );

  static const TextStyle textoSaldo = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: verdePrimario,
  );

  static const TextStyle textoBoton = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const InputDecoration decoracionCajasTexto = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    labelStyle: TextStyle(color: verdePrimario),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide.none,
    ),
    prefixIconColor: verdePrimario,
  );

  static ButtonStyle estiloBoton = ElevatedButton.styleFrom(
    backgroundColor: verdePrimario,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    elevation: 5,
  );
}
