import 'package:retail_application/ui/components/apz_toast.dart';
import 'package:flutter/material.dart';

class ToastExamplePage extends StatelessWidget {
  const ToastExamplePage({super.key});

  void _showSuccessToast(BuildContext context) {
    ApzToast.show(
      context,
      title: 'Success',
      message: 'Your operation was successful.',
      type: ToastType.success,
      alignment: ToastAlignment.bottomCenter,
    );
  }

  void _showErrorToast(BuildContext context) {
    ApzToast.show(
      context,
      title: 'Error',
      message: 'Something went wrong.',
      type: ToastType.error,
      alignment: ToastAlignment.topCenter,
    );
  }

  void _showWarningToast(BuildContext context) {
    ApzToast.show(
      context,
      title: 'Warning',
      message: 'Be careful while proceeding.',
      type: ToastType.warning,
    );
  }

  void _showInfoToast(BuildContext context) {
    ApzToast.show(
      context,
      title: 'Info',
      message: 'This is some useful information for you.',
      type: ToastType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzToast Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _showSuccessToast(context),
              child: const Text('Show Success Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showErrorToast(context),
              child: const Text('Show Error Toast (Top Alignment)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showWarningToast(context),
              child: const Text('Show Warning Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showInfoToast(context),
              child: const Text('Show Info Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
