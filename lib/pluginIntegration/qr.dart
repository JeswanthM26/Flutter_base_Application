import 'package:flutter/material.dart';
import 'package:apz_qr/apz_qr_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  void _showScanResult(String result) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanned'),
        content: Text('Result: $result'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop(); // Go back from the scanner screen
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: ApzQrScanner(
        callbacks: ApzQrScannerCallbacks(
          onScanSuccess: (Code? code) {
            if (code?.text != null) {
              _showScanResult(code!.text!);
            }
          },
          onScanFailure: (Code? code) {
            debugPrint('Scan failed: ${code?.error}');
          },
          onError: (Exception error) {
            debugPrint('Scanner error: $error');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Scanner Error: ${error.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}