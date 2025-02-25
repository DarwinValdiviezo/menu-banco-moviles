import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String cardNumber;
  final String expiry;
  final double balance;
  final bool isFrozen;

  CardItem({
    required this.cardNumber,
    required this.expiry,
    required this.balance,
    this.isFrozen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: isFrozen ? Colors.grey[400] : Colors.blueAccent,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 4)),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saldo:",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 5),
          Text(
            "\$${balance.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                "Exp: $expiry",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
