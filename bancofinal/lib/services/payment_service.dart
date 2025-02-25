import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payment_model.dart';
import '../models/transaction_model.dart';
import '../models/notification_model.dart';
import 'local_storage.dart';
import 'transaction_service.dart';
import 'balance_service.dart';
import 'card_service.dart';
import 'notification_service.dart';

class PaymentService {
  static const String _storageKey = "payments";

  // ✅ Obtener todos los pagos almacenados
  static Future<List<PaymentModel>> getPayments() async {
    final data = await LocalStorage.getData(_storageKey);
    if (data != null) {
      return (data as List).map((item) => PaymentModel.fromMap(item)).toList();
    }
    return [];
  }

  // ✅ Realizar un pago (transferencia a tarjeta)
  static Future<bool> makePayment(
    PaymentModel payment,
    BuildContext context,
  ) async {
    double currentBalance = await BalanceService.getBalance();

    if (payment.amount > currentBalance) {
      _showNotification(
        context,
        "❌ Saldo insuficiente para el pago",
        Colors.red,
      );
      return false;
    }

    bool transferSuccess = await CardService.transferToCard(
      payment.recipient,
      payment.amount,
    );
    if (!transferSuccess) {
      _showNotification(
        context,
        "❌ No se pudo transferir a la tarjeta",
        Colors.red,
      );
      return false;
    }

    // ✅ Restar saldo de la cuenta principal
    double newBalance = currentBalance - payment.amount;
    await BalanceService.updateBalance(newBalance);

    // ✅ Guardar la transacción en el historial
    TransactionModel transaction = TransactionModel(
      id: payment.id,
      type: "Transferencia",
      amount: payment.amount,
      date: DateFormat("dd/MM/yyyy").format(DateTime.now()),
      details: "Transferencia a tarjeta ${payment.recipient}",
    );

    await TransactionService.addTransaction(transaction);

    // Guardar el pago en el almacenamiento local
    List<PaymentModel> payments = await getPayments();
    payments.add(payment);
    await LocalStorage.saveData(
      _storageKey,
      payments.map((p) => p.toMap()).toList(),
    );

    // Registrar notificación en el historial de notificaciones
    NotificationModel notification = NotificationModel(
      id: UniqueKey().toString(),
      message:
          "Pago realizado de \$${payment.amount} a la tarjeta ${payment.recipient}",
      date: DateTime.now().toString(),
      isRead: false,
    );
    await NotificationService.addNotification(notification);

    _showNotification(context, "Pago realizado con éxito", Colors.green);

    return true;
  }

  // Mostrar alerta en pantalla
  static void _showAlert(
    BuildContext context,
    String title,
    String message,
    IconData icon,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar notificaciones en pantalla
  static void _showNotification(
    BuildContext context,
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
