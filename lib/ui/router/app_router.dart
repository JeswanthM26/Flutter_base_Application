import 'package:Retail_Application/ui/screens/login/login_screen.dart';
import 'package:Retail_Application/ui/screens/post_login/Dashboard_screen.dart';
import 'package:Retail_Application/ui/screens/post_login/accounts_dashboard_screen.dart';
import 'package:Retail_Application/ui/screens/post_login/profile_screen.dart';
import 'package:Retail_Application/ui/screens/pre_login/onboarding_screen.dart';
import 'package:Retail_Application/ui/widgets/account_screen.dart';
import 'package:Retail_Application/ui/widgets/menu_placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          // On web, skip onboarding and go to login
          if (kIsWeb) return '/login';
          return '/onboarding';
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const FooterHeaderScreen(),
      ),
      GoRoute(
        path: '/promotions',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Promotions'),
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PlaceholderScreen(title: 'Payments'),
      ),
      GoRoute(
        path: '/rewards',
        builder: (context, state) => const PlaceholderScreen(title: 'Rewards'),
      ),
      GoRoute(
        path: '/transfers',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Transfers'),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const PlaceholderScreen(title: 'Settings'),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const PlaceholderScreen(title: 'Help'),
      ),
      GoRoute(
        path: '/logout',
        builder: (context, state) => const PlaceholderScreen(title: 'Logout'),
      ),
      GoRoute(
        path: '/profile', // New route for profile
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/AccountsScreen', // New route for profile
        builder: (context, state) => const AccountDashboardScreen(),
      ),
    ],
  );
}
