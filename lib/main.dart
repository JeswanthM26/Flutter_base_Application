// // ignore_for_file: unused_import

// import 'package:Retail_Application/example/appz_alert_example.dart';
// import 'package:Retail_Application/example/appz_checkbox_example.dart';
// import 'package:Retail_Application/example/apz_dropdown_example.dart';
// import 'package:Retail_Application/example/apz_payment_example.dart';
// import 'package:Retail_Application/example/apz_phone_with_dropdown_example.dart';
// import 'package:Retail_Application/example/apz_searchbar_example.dart';
// import 'package:Retail_Application/example/apz_segment_control_example.dart';
// import 'package:Retail_Application/example/apz_toast_example.dart';
// import 'package:Retail_Application/l10n/app_localizations.dart';
// import 'package:Retail_Application/l10n/l10n.dart';
// import 'package:Retail_Application/ui/components/apz_dropdown.dart';
// import 'package:Retail_Application/ui/router/app_router.dart';
// import 'package:Retail_Application/ui/screens/auth_base_screen.dart';
// import 'package:Retail_Application/example/input_screen_example.dart';
// import 'package:Retail_Application/ui/screens/dashboard_screen.dart';
// import 'package:Retail_Application/ui/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/ui/screens/product_screen.dart';
// import 'package:Retail_Application/ui/screens/stock_screen.dart';
// import 'package:Retail_Application/ui/screens/weather_screen.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(const AppWrapper());
// }

// class AppWrapper extends StatelessWidget {
//   const AppWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => LocaleProvider(),
//       child: const MyApp(),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LocaleProvider>(context);

//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         locale: provider.locale,
//         localizationsDelegates: const [
//           AppLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         supportedLocales: L10n.all,
//         home: PaymentCardExample());
//     // routerConfig: AppRouter.router);
//   }
// }

import 'package:Retail_Application/l10n/l10n.dart';
import 'package:Retail_Application/ui/router/app_router.dart';
import 'package:Retail_Application/ui/screens/post_login/Dashboard_screen.dart';
import 'package:Retail_Application/ui/widgets/upcoming_payments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Retail_Application/l10n/app_localizations.dart';
import 'package:Retail_Application/ui/components/apz_themed_background.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const MyApp(),
    );
  }
}

// Converted MyApp to a StatefulWidget to manage theme state
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variable to hold the current theme mode
  ThemeMode _themeMode = ThemeMode.light;

  // Function to toggle the theme
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: provider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      themeMode: _themeMode, // Use the state variable here
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      builder: (context, child) {
        // Use a Stack to place the FloatingActionButton on top of the main content
        return Stack(
          children: [
            // The main app content with its background
            ApzThemedBackground(
              child: child!,
            ),
            // The theme toggle button
            Positioned(
              bottom: 80, // Positioned above the bottom navigation bar
              right: 20,
              child: FloatingActionButton(
                onPressed: _toggleTheme,
                child: const Icon(Icons.brightness_6),
              ),
            ),
          ],
        );
      },
      // routerConfig: AppRouter.router,
      home: FooterHeaderScreen(),
      // home: PaymentCardExample(),
    );
  }
}
