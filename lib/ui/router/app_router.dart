import 'package:Retail_Application/ui/screens/login/login_screen.dart';
import 'package:Retail_Application/ui/screens/pre_login/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          if (kIsWeb) {
            // On web, skip onboarding and go to products instead
            return const LoginScreen();
          }
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
