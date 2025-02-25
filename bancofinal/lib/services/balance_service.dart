import 'package:shared_preferences/shared_preferences.dart';

class BalanceService {
  static const String balanceKey = "user_balance";

  // Obtener el saldo disponible
  static Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(balanceKey) ?? 1234.56;
  }

  // Actualizar el saldo después de un pago
  static Future<void> updateBalance(double newBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(balanceKey, newBalance);
  }
}
