import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricTest extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> authenticate() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      bool isSupported = await auth.isDeviceSupported();
      print('Can check: $canCheck, Device supported: $isSupported');

      if (!canCheck || !isSupported) {
        print('Biometrics not available');
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      print('Authenticated: $authenticated');
    } catch (e) {
      print('Authentication error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: authenticate,
          child: Text('Authenticate'),
        ),
      ),
    );
  }
}
