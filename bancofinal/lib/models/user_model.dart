class UserModel {
  String id;
  String name;
  String email;
  double balance;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'balance': balance};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      balance: map['balance'],
    );
  }
}
