import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CardService {
  static const String cardsKey = "user_cards";

  // Obtener todas las tarjetas guardadas
  static Future<List<Map<String, dynamic>>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    String? cardsJson = prefs.getString(cardsKey);
    if (cardsJson == null) return [];

    List<Map<String, dynamic>> cards = List<Map<String, dynamic>>.from(
      json.decode(cardsJson),
    );

    // Asegurar que cada tarjeta tenga valores correctos
    for (var card in cards) {
      card["balance"] = (card["balance"] ?? 0.0).toDouble();
      card["isFrozen"] = card["isFrozen"] ?? false;
    }

    return cards;
  }

  // Guardar la lista de tarjetas
  static Future<void> saveCards(List<Map<String, dynamic>> cards) async {
    final prefs = await SharedPreferences.getInstance();
    String cardsJson = json.encode(cards);
    await prefs.setString(cardsKey, cardsJson);
  }

  // Agregar una nueva tarjeta (con balance independiente)
  static Future<void> addCard(Map<String, dynamic> newCard) async {
    List<Map<String, dynamic>> cards = await getCards();
    newCard["balance"] = 0.0;
    newCard["isFrozen"] = false;
    cards.add(newCard);
    await saveCards(cards);
  }

  static Future<bool> transferToCard(String cardNumber, double amount) async {
    List<Map<String, dynamic>> cards = await getCards();
    bool success = false;

    for (var card in cards) {
      if (card["cardNumber"] == cardNumber) {
        if (card["isFrozen"] == true) {
          print("Tarjeta $cardNumber está congelada. No se puede transferir.");
          return false;
        }

        double newBalance = (card["balance"] ?? 0.0) + amount;
        card["balance"] = newBalance;

        print("Nuevo saldo en tarjeta $cardNumber: $newBalance");

        success = true;
        break;
      }
    }

    if (success) {
      await saveCards(cards);
      print("Tarjetas guardadas correctamente en SharedPreferences.");
    } else {
      print("No se encontró la tarjeta $cardNumber para actualizar.");
    }

    return success;
  }

  // Retirar dinero de una tarjeta
  static Future<bool> withdrawFromCard(String cardNumber, double amount) async {
    List<Map<String, dynamic>> cards = await getCards();
    bool success = false;

    for (var card in cards) {
      if (card["cardNumber"] == cardNumber) {
        if (card["isFrozen"] == true) return false;
        if (card["balance"] < amount) return false;
        card["balance"] -= amount;
        success = true;
        break;
      }
    }

    if (success) {
      await saveCards(cards);
    }
    return success;
  }

  // Eliminar una tarjeta
  static Future<void> removeCard(String cardNumber) async {
    List<Map<String, dynamic>> cards = await getCards();
    cards.removeWhere((card) => card["cardNumber"] == cardNumber);
    await saveCards(cards);
  }

  // Cambiar estado de congelamiento (activar/desactivar)
  static Future<void> toggleFreezeCard(String cardNumber) async {
    List<Map<String, dynamic>> cards = await getCards();
    for (var card in cards) {
      if (card["cardNumber"] == cardNumber) {
        card["isFrozen"] = !(card["isFrozen"] ?? false);
        break;
      }
    }
    await saveCards(cards);
  }

  // Obtener el balance de una tarjeta específica
  static Future<double> getCardBalance(String cardNumber) async {
    List<Map<String, dynamic>> cards = await getCards();
    for (var card in cards) {
      if (card["cardNumber"] == cardNumber) {
        return (card["balance"] ?? 0.0).toDouble();
      }
    }
    return 0.0;
  }
}
