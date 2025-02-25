import 'package:flutter/material.dart';
import 'payments_screen.dart';
import 'transactions_screen.dart';
import 'cards_screen.dart';
import 'notifications_screen.dart';
import '../../widgets/card_item.dart';
import '../../widgets/quick_action.dart';
import '../../services/balance_service.dart';
import '../../services/card_service.dart';
import '../../services/transaction_service.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "Darwin Valdiviezo";
  final String userEmail = "darwin.valdiviezo@gmail.com";
  double balance = 1234.56;
  List<Map<String, dynamic>> userCards = [];

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _loadCards();
  }

  Future<void> _loadBalance() async {
    double savedBalance = await BalanceService.getBalance();
    setState(() {
      balance = savedBalance;
    });
  }

  Future<void> _loadCards() async {
    List<Map<String, dynamic>> savedCards = await CardService.getCards();
    setState(() {
      userCards = savedCards;
    });

    print("Tarjetas después de actualizar en HomeScreen: $userCards");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        title: Text(
          'Mi Banco',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: _logout,
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    "\$${balance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _recargarSaldo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Recargar Saldo",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Accesos Rápidos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuickAction(
                  icon: Icons.payment,
                  label: "Pagos",
                  onTap: () => _navigateTo(context, PaymentsScreen()),
                ),
                QuickAction(
                  icon: Icons.history,
                  label: "Historial",
                  onTap: () => _navigateTo(context, TransactionsScreen()),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuickAction(
                  icon: Icons.credit_card,
                  label: "Tarjetas",
                  onTap: () => _navigateTo(context, CardsScreen()),
                ),
                QuickAction(
                  icon: Icons.notifications,
                  label: "Notificaciones",
                  onTap: () => _navigateTo(context, NotificationsScreen()),
                ),
              ],
            ),
            SizedBox(height: 20),

            Text(
              "Mis Tarjetas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10),
            userCards.isEmpty
                ? Center(
                  child: Text(
                    "No tienes tarjetas agregadas",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
                : SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: userCards.length,
                    itemBuilder: (context, index) {
                      var card = userCards[index];
                      return CardItem(
                        cardNumber: card["cardNumber"],
                        expiry: card["expiry"],
                        balance: card["balance"] ?? 0.0,
                        isFrozen: card["isFrozen"] ?? false,
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }

  void _recargarSaldo() {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Recargar Saldo"),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Monto"),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Confirmar"),
              onPressed: () async {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Monto inválido"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                double newBalance = balance + amount;
                await BalanceService.updateBalance(newBalance);
                await TransactionService.addTransaction(
                  TransactionModel(
                    id: UniqueKey().toString(),
                    type: "Recarga",
                    amount: amount,
                    date: DateFormat("dd/MM/yyyy").format(DateTime.now()),
                    details: "Recarga de saldo",
                  ),
                );

                setState(() {
                  balance = newBalance;
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Saldo Recargado"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) {
      _loadBalance();
      _loadCards();
    });
  }
}
