import 'package:flutter/material.dart';

// Mostrar un snackbar con mensaje
void showSnackbar(
  BuildContext context,
  String message, {
  Color color = Colors.green,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    ),
  );
}

// Validar si un campo está vacío
bool isFieldEmpty(String value) {
  return value.trim().isEmpty;
}

// Validar formato de correo electrónico
bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}
