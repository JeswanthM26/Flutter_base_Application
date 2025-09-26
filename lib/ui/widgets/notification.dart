import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:retail_application/models/Notification/notification_model.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:intl/intl.dart';
import '../../themes/apz_app_themes.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late Future<List<NotificationModel>> _notificationsFuture;

  List<NotificationModel> _notifications = [];

  final Set<int> _readNotifications = {};

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
        content: ApzText(
          label: 'Notification deleted',
          color: AppColors.primary_text(context),
        ),
        backgroundColor: AppColors.inverse_text(context),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primary_text(context),
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

  String _formatNotificationDate(DateTime date, bool isToday) {
    if (isToday) {
      return DateFormat.jm().format(date); // e.g., 5:08 PM
    } else {
      return DateFormat.MMMd().format(date); // e.g., Sep 23
    }
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ApzText(
        label: title,
        fontWeight: ApzFontWeight.headingsBold,
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification, bool isToday) {
    final rawDate =
        notification.createTs.replaceAll(RegExp(r'\s+'), ' ').trim();
    final notificationDate = DateFormat("dd MMM yy HH:mm").parse(rawDate);

    // final DateTime notificationDate =
    //     DateFormat("dd MMM yy HH:mm").parse(notification.createTs);

    return Slidable(
      key: ValueKey(notification.notifId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.35,
        children: [
          CustomSlidableAction(
            onPressed: (context) {
              final index = _notifications
                  .indexWhere((n) => n.notifId == notification.notifId);

              if (index != -1) {
                _deleteNotification(index);
              }
            },
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.inverse_text(context),
            padding: EdgeInsets.zero,
            child: Container(
              height: 80,
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.semantic_error(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: ApzText(
                  label: 'Delete',
                  fontWeight: ApzFontWeight.titlesSemibold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () {
              setState(() {
                _readNotifications.add(notification.notifId);
              });
            },
            leading: !_readNotifications.contains(notification.notifId)
                ? Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary(context),
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ApzText(
                    label: notification.title,
                    fontWeight: ApzFontWeight.titlesSemibold,
                  ),
                ),
                ApzText(
                  label: _formatNotificationDate(notificationDate, isToday),
                  color: AppColors.secondary_text(context),
                ),
              ],
            ),
            subtitle: ApzText(
              label: notification.notifMsg,
              fontWeight: ApzFontWeight.bodyRegular,
            ),
          ),
        ),
      ),
    );
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
          final notifications = snapshot.data!;

          final now = DateTime.now();

          final today = DateTime(now.year, now.month, now.day);

          final sevenDaysAgo = today.subtract(const Duration(days: 7));

          final todayNotifications = <NotificationModel>[];

          final last7DaysNotifications = <NotificationModel>[];

          final olderNotifications = <NotificationModel>[];

          for (final notification in notifications) {
            try {
              final rawDate =
                  notification.createTs.replaceAll(RegExp(r'\s+'), ' ').trim();
              final notificationDate =
                  DateFormat("dd MMM yy HH:mm").parse(rawDate);

              if (notificationDate.isAfter(today)) {
                todayNotifications.add(notification);
              } else if (notificationDate.isAfter(sevenDaysAgo)) {
                last7DaysNotifications.add(notification);
              } else {
                olderNotifications.add(notification);
              }
            } catch (e) {
              debugPrint(
                  'Invalid date for notification ${notification.notifId}: ${notification.createTs}');
              olderNotifications.add(notification);
            }
          }

          final List<Widget> groupedItems = [];

          if (todayNotifications.isNotEmpty) {
            groupedItems.add(_buildHeader('Today'));

            groupedItems.addAll(
                todayNotifications.map((n) => _buildNotificationItem(n, true)));
          }

          if (last7DaysNotifications.isNotEmpty) {
            groupedItems.add(_buildHeader('Last 7 Days'));

            groupedItems.addAll(last7DaysNotifications
                .map((n) => _buildNotificationItem(n, false)));
          }

          if (olderNotifications.isNotEmpty) {
            groupedItems.add(_buildHeader('Older'));

            groupedItems.addAll(olderNotifications
                .map((n) => _buildNotificationItem(n, false)));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0),
            itemCount: groupedItems.length,
            itemBuilder: (context, index) {
              return groupedItems[index];
            },
          );
        }
      },
    );
  }
}
