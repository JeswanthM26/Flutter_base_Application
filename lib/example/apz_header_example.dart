import 'package:flutter/material.dart';
import 'package:retail_application/ui/components/apz_header.dart'; // Adjust the path if needed

class ExampleHeaderScreen extends StatelessWidget {
  const ExampleHeaderScreen({super.key});

  // Example methods for navigation/tap handling
  void _openProfile(BuildContext context) {
    // Navigation logic to profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile tapped")),
    );
  }

  void _openNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notifications tapped")),
    );
  }

  void _onSearchTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Search tapped")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Header Example"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ApzHeader(
            hasNotification: true,
            avatarUrl: "https://placehold.co/40x40",
            onProfileTap: () => _openProfile(context),
            onNotificationTap: () => _openNotifications(context),
            onSearchTap: () => _onSearchTap(context),
          ),
          // Rest of your screen content goes here
          const Expanded(
            child: Center(child: Text("Screen content below header")),
          ),
        ],
      ),
    );
  }
}
