// import 'package:retail_application/l10n/l10n.dart';
// import 'package:retail_application/ui/router/app_router.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:retail_application/l10n/app_localizations.dart';
// import 'package:retail_application/ui/components/apz_themed_background.dart';

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

// // Converted MyApp to a StatefulWidget to manage theme state
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // Variable to hold the current theme mode
//   ThemeMode _themeMode = ThemeMode.light;

//   // Function to toggle the theme
//   void _toggleTheme() {
//     setState(() {
//       _themeMode =
//           _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LocaleProvider>(context);

//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       locale: provider.locale,
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: L10n.all,
//       themeMode: _themeMode, // Use the state variable here
//       theme: ThemeData(
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: Colors.transparent,
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: Colors.transparent,
//       ),
//       builder: (context, child) {
//         // Use a Stack to place the FloatingActionButton on top of the main content
//         return Stack(
//           children: [
//             // The main app content with its background
//             ApzThemedBackground(
//               child: child!,
//             ),
//             // The theme toggle button
//             Positioned(
//               bottom: 140, // Positioned above the bottom navigation bar
//               right: 20,
//               child: FloatingActionButton(
//                 onPressed: _toggleTheme,
//                 child: const Icon(Icons.brightness_6),
//               ),
//             ),
//           ],
//         );
//       },
//       routerConfig: AppRouter.router,
//       //home: FooterHeaderScreen(),
//     );
//   }
// }
import 'package:retail_application/l10n/l10n.dart';
import 'package:retail_application/themes/apz_theme_provider.dart';
import 'package:retail_application/ui/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:retail_application/l10n/app_localizations.dart';
import 'package:retail_application/ui/components/apz_themed_background.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // add ThemeProvider
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: provider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      themeMode: themeProvider.themeMode, // from provider
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      builder: (context, child) {
        return ApzThemedBackground(
          child: child!,
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
