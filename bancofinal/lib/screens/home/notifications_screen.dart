import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../models/notification_model.dart';
import '../../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    List<NotificationModel> savedNotifications =
        await NotificationService.getNotifications();
    setState(() {
      notifications = savedNotifications;
    });
  }

  Future<void> _markAsRead(String notificationId) async {
    await NotificationService.markAsRead(notificationId);
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body:
          notifications.isEmpty
              ? Center(child: Text("No tienes notificaciones"))
              : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  NotificationModel notification = notifications[index];

                  return NotificationItem(
                    notification: notification,
                    onMarkAsRead: () => _markAsRead(notification.id),
                  );
                },
              ),
    );
  }
}
