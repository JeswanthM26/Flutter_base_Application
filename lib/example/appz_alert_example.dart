import 'package:retail_application/ui/components/apz_alert.dart';
import 'package:flutter/material.dart';

class AppzAlertExample extends StatelessWidget {
  const AppzAlertExample({super.key});

  void _showAlert(BuildContext context, ApzAlertMessageType type) {
    ApzAlert.show(
      context,
      title: "Sample ${type.name.toUpperCase()} Alert",
      message:
          "This is a ${type.name} alert message to demonstrate the AppzAlert component.",
      messageType: type,
      buttons: ["OK", "Cancel"],
      onButtonPressed: (btn) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You pressed: $btn")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AppzAlert Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _showAlert(context, ApzAlertMessageType.success),
              child: const Text("Show Success Alert"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showAlert(context, ApzAlertMessageType.error),
              child: const Text("Show Error Alert"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showAlert(context, ApzAlertMessageType.info),
              child: const Text("Show Info Alert"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showAlert(context, ApzAlertMessageType.warning),
              child: const Text("Show Warning Alert"),
            ),
            const Divider(height: 32),
            ElevatedButton(
              onPressed: () {
                ApzAlert.show(
                  context,
                  title: "Single Button Alert",
                  message: "This alert only has one button.",
                  messageType: ApzAlertMessageType.info,
                  buttons: ["Got it"],
                );
              },
              child: const Text("Show Single Button Alert"),
            ),
          ],
        ),
      ),
    );
  }
}
