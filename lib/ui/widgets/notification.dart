import 'package:retail_application/models/Notification/notification_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late Future<List<NotificationModel>> _notificationsFuture;

  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();

    _notificationsFuture = _loadNotifications();
  }

  Future<List<NotificationModel>> _loadNotifications() async {
    final String jsonString =
        await rootBundle.loadString('mock/Notifications/notifications.json');

    final List<NotificationModel> notifications =
        notificationModelFromJson(jsonString);

    _notifications = notifications;

    return notifications;
  }

  void _deleteNotification(int index) {
    final deletedNotification = _notifications.removeAt(index);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _undoDelete(index, deletedNotification);
          },
        ),
      ),
    );
  }

  void _undoDelete(int index, NotificationModel notification) {
    setState(() {
      _notifications.insert(index, notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationModel>>(
      future: _notificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No notifications'));
        } else {
          return ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];

              //  return Slidable(
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Slidable(
                  key: ValueKey(notification.notifId),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => _deleteNotification(index),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Material(
                    child: ListTile(
                      title: Text(notification.title),
                      subtitle: Text(notification.notifMsg),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
