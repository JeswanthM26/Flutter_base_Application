import 'package:retail_application/ui/screens/Profile/profile_screen.dart';

import 'package:retail_application/ui/widgets/notification.dart';

import 'package:flutter/material.dart';

class ApzNotification extends StatelessWidget {
  const ApzNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProfileHeaderWidget(
            title: 'Notifications',
            onBackPressed: () {
              Navigator.of(context).pop();
            },
            trailingIcon: Icons.more_vert,
            onActionPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("More options pressed"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Expanded(
            child: NotificationWidget(),
          ),
        ],
      ),
    );
  }
}
