class NotificationModel {
  final String id;
  final String message;
  final String date;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.message,
    required this.date,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {"id": id, "message": message, "date": date, "isRead": isRead};
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map["id"] ?? "",
      message: map["message"] ?? "Notificación",
      date: map["date"] ?? "",
      isRead: map["isRead"] ?? false,
    );
  }
}
