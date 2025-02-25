class PaymentModel {
  String id;
  String recipient;
  double amount;
  String date;
  String cardUsed;

  PaymentModel({
    required this.id,
    required this.recipient,
    required this.amount,
    required this.date,
    required this.cardUsed,
  });

  // Convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipient': recipient,
      'amount': amount,
      'date': date,
      'cardUsed': cardUsed,
    };
  }

  // Convertir desde Map
  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'],
      recipient: map['recipient'],
      amount: map['amount'],
      date: map['date'],
      cardUsed: map['cardUsed'],
    );
  }
}
