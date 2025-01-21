import 'package:flutter/material.dart';
import '../modelo/usuarios_modelo.dart';
import '../controlador/operaciones_controlador.dart';
import '../tema/estilo.dart';

class CalculoInteresesVista extends StatefulWidget {
  final UsuarioModelo usuario;

  CalculoInteresesVista({required this.usuario});

  @override
  _CalculoInteresesVistaState createState() => _CalculoInteresesVistaState();
}

class _CalculoInteresesVistaState extends State<CalculoInteresesVista> {
  final TextEditingController _tasaController = TextEditingController();
  final OperacionesControlador _controlador = OperacionesControlador();

  void _mostrarDialogo(String mensaje, {bool esError = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            esError ? "Error" : "Resultado",
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

  void _calcularInteres() {
    final double tasa = double.tryParse(_tasaController.text) ?? 0.0;

    try {
      final interes = _controlador.calcularInteres(widget.usuario.saldo, tasa);

      _mostrarDialogo("Interés generado: \$${interes.toStringAsFixed(2)}");
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
                  controller: _tasaController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18),
                  decoration: Estilo.decoracionCajasTexto.copyWith(
                    labelText: "Ingrese la tasa de interés (%)",
                    prefixIcon: Icon(Icons.percent),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calcularInteres,
                  style: Estilo.estiloBoton,
                  child: Text("Calcular Interés", style: Estilo.textoBoton),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
