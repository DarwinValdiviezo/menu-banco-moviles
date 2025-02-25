import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/formatter.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          transaction.type == "pago"
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: transaction.type == "pago" ? Colors.red : Colors.green,
        ),
        title: Text(transaction.details),
        subtitle: Text(formatDate(transaction.date)),
        trailing: Text(
          formatCurrency(transaction.amount),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }
}
