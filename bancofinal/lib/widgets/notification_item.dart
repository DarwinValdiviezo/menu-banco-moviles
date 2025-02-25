import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkAsRead;

  NotificationItem({required this.notification, required this.onMarkAsRead});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: notification.isRead ? Colors.grey : Colors.blue,
        ),
        title: Text(notification.message),
        subtitle: Text(notification.date),
        trailing:
            notification.isRead
                ? null
                : IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: onMarkAsRead,
                ),
      ),
    );
  }
}
