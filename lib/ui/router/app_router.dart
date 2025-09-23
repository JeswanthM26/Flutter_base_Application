import 'package:retail_application/models/dashboard/account_model.dart';
import 'package:retail_application/models/dashboard/customer_model.dart';
import 'package:retail_application/ui/screens/login/login_screen.dart';
import 'package:retail_application/ui/screens/post_login/Dashboard_screen.dart';
import 'package:retail_application/ui/screens/Profile/profile_edit.dart';
import 'package:retail_application/ui/screens/accountDashboard/account_details_screen.dart';
import 'package:retail_application/ui/screens/accountDashboard/accounts_dashboard_screen.dart';
import 'package:retail_application/ui/screens/Profile/profile_screen.dart';
import 'package:retail_application/ui/screens/accountDashboard/transactions_screen.dart';
import 'package:retail_application/ui/screens/post_login/Notification_screen.dart';
import 'package:retail_application/ui/screens/pre_login/onboarding_screen.dart';
import 'package:retail_application/ui/widgets/menu_placeholder.dart';
import 'package:retail_application/ui/widgets/notification.dart';
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
        path: '/edit',
        builder: (context, state) {
          final customer = state.extra as CustomerModel;
          return EditScreen(customer: customer);
        },
      ),
      GoRoute(
        path: '/AccountsScreen', // New route for profile
        builder: (context, state) => const AccountDashboardScreen(),
      ),
      GoRoute(
        path: '/accountdetails',
        builder: (context, state) {
          final account = state.extra as AccountModel; // get account from extra
          return AccountDetailsScreen(account: account);
        },
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) {
          final account = state.extra as AccountModel;
          return TransactionsScreen(account: account);
        },
      ),
      GoRoute(
        path: '/Notifications',
        builder: (context, state) => const ApzNotificationExample(),
      )
    ],
  );
}
