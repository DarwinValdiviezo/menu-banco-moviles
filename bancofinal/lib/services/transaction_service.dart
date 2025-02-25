import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class TransactionService {
  static const String _storageKey = "transactions";

  // Obtener todas las transacciones guardadas
  static Future<List<TransactionModel>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    String? transactionsJson = prefs.getString(_storageKey);
    if (transactionsJson == null) return [];

    List<dynamic> jsonList = json.decode(transactionsJson);
    return jsonList.map((item) => TransactionModel.fromMap(item)).toList();
  }

  // Guardar la lista de transacciones
  static Future<void> saveTransactions(
    List<TransactionModel> transactions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String transactionsJson = json.encode(
      transactions.map((tx) => tx.toMap()).toList(),
    );
    await prefs.setString(_storageKey, transactionsJson);
  }

  static Future<void> addTransaction(TransactionModel transaction) async {
    List<TransactionModel> transactions = await getTransactions();
    transactions.insert(0, transaction);
    await saveTransactions(
      transactions,
    ); // Guardar correctamente en almacenamiento
  }
}
