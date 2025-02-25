import 'package:flutter/material.dart';
import '../config/theme.dart';

class BalanceCard extends StatelessWidget {
  final double balance;

  BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Saldo Disponible",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "\$${balance.toStringAsFixed(2)}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text("Cuenta Principal", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
