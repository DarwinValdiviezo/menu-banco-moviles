class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final String date;
  final String details;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "amount": amount,
      "date": date,
      "details": details,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map["id"] ?? "",
      type: map["type"] ?? "Desconocido",
      amount: (map["amount"] ?? 0.0).toDouble(),
      date: map["date"] ?? "",
      details: map["details"] ?? "",
    );
  }
}
