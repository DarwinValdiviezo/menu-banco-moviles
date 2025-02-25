class CardModel {
  String id;
  String cardNumber;
  String cardHolder;
  String expiryDate;
  bool isFrozen;

  CardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    this.isFrozen = false,
  });

  // Convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolder': cardHolder,
      'expiryDate': expiryDate,
      'isFrozen': isFrozen,
    };
  }

  // Convertir desde Map
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'],
      cardNumber: map['cardNumber'],
      cardHolder: map['cardHolder'],
      expiryDate: map['expiryDate'],
      isFrozen: map['isFrozen'],
    );
  }
}
