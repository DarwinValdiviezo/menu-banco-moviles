import 'package:flutter/material.dart';
import '../modelo/usuarios_modelo.dart';
import '../controlador/operaciones_controlador.dart';
import '../tema/estilo.dart';

class AgregarMontoVista extends StatefulWidget {
  final UsuarioModelo usuario;
  final Function(double) actualizarSaldo;

  AgregarMontoVista({required this.usuario, required this.actualizarSaldo});

  @override
  _AgregarMontoVistaState createState() => _AgregarMontoVistaState();
}

class _AgregarMontoVistaState extends State<AgregarMontoVista> {
  final TextEditingController _montoController = TextEditingController();
  final OperacionesControlador _controlador = OperacionesControlador();

  void _mostrarDialogo(String mensaje, {bool esError = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            esError ? "Error" : "Éxito",
            style: TextStyle(
              color: esError ? Colors.red : Estilo.verdePrimario,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            mensaje,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Aceptar",
                style: TextStyle(color: Estilo.verdePrimario),
              ),
            ),
          ],
        );
      },
    );
  }

  void _agregarMonto() {
    final double monto = double.tryParse(_montoController.text) ?? 0.0;

    try {
      final nuevoSaldo = _controlador.agregarMonto(widget.usuario.saldo, monto);
      widget.usuario.saldo = nuevoSaldo;
      widget.actualizarSaldo(nuevoSaldo);

      _mostrarDialogo(
        "Monto agregado con éxito. Nuevo saldo: \$${nuevoSaldo.toStringAsFixed(2)}",
      );
    } catch (e) {
      _mostrarDialogo(e.toString().replaceFirst("Exception: ", ""),
          esError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Balance Total: \$${widget.usuario.saldo.toStringAsFixed(2)}",
                  style: Estilo.textoSaldo,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _montoController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18),
                  decoration: Estilo.decoracionCajasTexto.copyWith(
                    labelText: "Ingrese el monto a agregar",
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _agregarMonto,
                  style: Estilo.estiloBoton,
                  child: Text("Agregar Monto", style: Estilo.textoBoton),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
