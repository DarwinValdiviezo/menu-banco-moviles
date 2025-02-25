import 'package:flutter/material.dart';
import '../../services/card_service.dart';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<Map<String, dynamic>> userCards = [];
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List<Map<String, dynamic>> savedCards = await CardService.getCards();
    setState(() {
      userCards = savedCards;
    });
  }

  void _addCard() {
    String cardNumber = cardNumberController.text.trim();
    String expiry = expiryController.text.trim();

    if (cardNumber.length != 16 || expiry.isEmpty) {
      _showMessage(
        "Ingrese un número de tarjeta válido y una fecha de expiración",
        Colors.red,
      );
      return;
    }

    Map<String, dynamic> newCard = {
      "cardNumber": cardNumber,
      "expiry": expiry,
      "isFrozen": false,
    };

    CardService.addCard(newCard).then((_) {
      _showMessage("Tarjeta agregada con éxito", Colors.green);
      _loadCards();
      cardNumberController.clear();
      expiryController.clear();
    });
  }

  void _removeCard(String cardNumber) {
    CardService.removeCard(cardNumber).then((_) {
      _showMessage("Tarjeta eliminada", Colors.red);
      _loadCards();
    });
  }

  void _toggleFreezeCard(String cardNumber) {
    CardService.toggleFreezeCard(cardNumber).then((_) {
      _showMessage("Estado de la tarjeta actualizado", Colors.blue);
      _loadCards();
    });
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
        title: Text("Mis Tarjetas"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formulario para agregar tarjeta
            Text(
              "Agregar Nueva Tarjeta",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.credit_card, color: Colors.grey),
                hintText: "Número de Tarjeta",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                counterText: "",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: expiryController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.date_range, color: Colors.grey),
                hintText: "MM/AA",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _addCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                child: Text(
                  "Agregar Tarjeta",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Lista de tarjetas
            Text(
              "Mis Tarjetas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child:
                  userCards.isEmpty
                      ? Center(
                        child: Text(
                          "No tienes tarjetas guardadas",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: userCards.length,
                        itemBuilder: (context, index) {
                          var card = userCards[index];
                          bool isFrozen = card["isFrozen"] ?? false;
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color:
                                isFrozen ? Colors.grey[300] : Colors.blueAccent,
                            child: ListTile(
                              title: Text(
                                "**** **** **** ${card["cardNumber"].substring(12)}",
                                style: TextStyle(
                                  color:
                                      isFrozen ? Colors.black87 : Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                "Expira: ${card["expiry"]}",
                                style: TextStyle(
                                  color:
                                      isFrozen
                                          ? Colors.black54
                                          : Colors.white70,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isFrozen ? Icons.lock_open : Icons.lock,
                                      color: Colors.white,
                                    ),
                                    onPressed:
                                        () => _toggleFreezeCard(
                                          card["cardNumber"],
                                        ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed:
                                        () => _removeCard(card["cardNumber"]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
