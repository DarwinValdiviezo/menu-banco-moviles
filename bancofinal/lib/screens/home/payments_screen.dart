import 'package:flutter/material.dart';
import '../../services/balance_service.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  double currentBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    double savedBalance = await BalanceService.getBalance();
    setState(() {
      currentBalance = savedBalance;
    });
  }

  void _makePayment() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    String cardNumber = cardNumberController.text.trim();

    if (amount <= 0 || amount > currentBalance) {
      _showMessage("Monto inválido o insuficiente saldo", Colors.red);
      return;
    }

    if (cardNumber.isEmpty || cardNumber.length < 4) {
      _showMessage("Ingrese un número de tarjeta válido", Colors.red);
      return;
    }

    // Confirmación antes de realizar el pago
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Pago"),
          content: Text(
            "¿Deseas realizar un pago de \$${amount.toStringAsFixed(2)} a la tarjeta **** ${cardNumber.substring(cardNumber.length - 4)}?",
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Confirmar"),
              onPressed: () async {
                Navigator.of(context).pop();
                double newBalance = currentBalance - amount;
                await BalanceService.updateBalance(newBalance);
                _showMessage("Pago realizado con éxito", Colors.green);
                _loadBalance();
                amountController.clear();
                cardNumberController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Realizar Pago"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de saldo disponible
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Saldo Disponible",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "\$${currentBalance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Campo de monto
            Text(
              "Monto a Pagar",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.attach_money, color: Colors.grey),
                hintText: "Ingrese el monto",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 20),

            // Campo de tarjeta
            Text(
              "Número de Tarjeta",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.credit_card, color: Colors.grey),
                hintText: "**** **** **** ****",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                counterText: "",
              ),
            ),
            SizedBox(height: 20),

            // Botón de realizar pago
            Center(
              child: ElevatedButton(
                onPressed: _makePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                ),
                child: Text(
                  "Realizar Pago",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
