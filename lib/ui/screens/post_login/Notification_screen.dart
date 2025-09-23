import 'package:retail_application/ui/screens/Profile/profile_screen.dart';

import 'package:retail_application/ui/widgets/notification.dart';

import 'package:flutter/material.dart';

class ApzNotificationExample extends StatelessWidget {
  const ApzNotificationExample({super.key});

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
          ),
          const Expanded(
            child: NotificationWidget(),
          ),
        ],
      ),
    );
  }
}
