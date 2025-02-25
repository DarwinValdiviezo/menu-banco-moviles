import '../models/notification_model.dart';
import 'local_storage.dart';

class NotificationService {
  static const String _storageKey = "notifications";

  static Future<List<NotificationModel>> getNotifications() async {
    final data = await LocalStorage.getData(_storageKey);
    if (data != null) {
      return (data as List)
          .map((item) => NotificationModel.fromMap(item))
          .toList();
    }
    return [];
  }

  static Future<void> addNotification(NotificationModel notification) async {
    List<NotificationModel> notifications = await getNotifications();
    notifications.insert(0, notification); // Agregar al inicio
    await LocalStorage.saveData(
      _storageKey,
      notifications.map((n) => n.toMap()).toList(),
    );
  }

  static Future<void> markAsRead(String notificationId) async {
    List<NotificationModel> notifications = await getNotifications();
    for (var notification in notifications) {
      if (notification.id == notificationId) {
        notification.isRead = true;
      }
    }
    await LocalStorage.saveData(
      _storageKey,
      notifications.map((n) => n.toMap()).toList(),
    );
  }
}
