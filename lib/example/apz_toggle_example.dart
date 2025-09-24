import 'package:retail_application/ui/components/apz_toogle_switch.dart';
import 'package:flutter/material.dart';

class ToggleButtonDemoPage extends StatefulWidget {
  const ToggleButtonDemoPage({super.key});

  @override
  State<ToggleButtonDemoPage> createState() => _ToggleButtonDemoPageState();
}

class _ToggleButtonDemoPageState extends State<ToggleButtonDemoPage> {
  // Controller for managing toggle state
  final ApzToggleController toggleController = ApzToggleController(false);

  // Current toggle value for display
  bool currentToggleValue = false;

  @override
  void initState() {
    super.initState();
    currentToggleValue = toggleController.value;
    toggleController.addListener(() {
      setState(() {
        currentToggleValue = toggleController.value;
      });
    });
  }

  @override
  void dispose() {
    toggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ApzToggleButton Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApzToggleButton(
              label: 'Enable Notifications',
              controller: toggleController,
              size: ApzToggleSize.large,
              isDisabled: false,
              onChanged: (bool value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Toggle changed to: $value')),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Current Toggle Value: $currentToggleValue',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                toggleController.value = !toggleController.value;
              },
              child: const Text('Toggle Programmatically'),
            ),
          ],
        ),
      ),
    );
  }
}
