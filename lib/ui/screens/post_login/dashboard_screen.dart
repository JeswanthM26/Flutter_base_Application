import 'package:Retail_Application/example/appz_button_example.dart';
import 'package:Retail_Application/example/appz_radio_example.dart';
import 'package:Retail_Application/example/apz_dropdown_example.dart';
import 'package:Retail_Application/example/apz_searchbar_example.dart';
import 'package:Retail_Application/themes/apz_theme_provider.dart';
import 'package:Retail_Application/ui/components/apz_footer_scaffold.dart';
import 'package:Retail_Application/ui/screens/accountDashboard/accounts_dashboard_screen.dart';
import 'package:Retail_Application/ui/widgets/account_dashoard.dart';
import 'package:Retail_Application/ui/widgets/favourite_transactions.dart';
import 'package:Retail_Application/ui/widgets/menu_screen.dart';
import 'package:Retail_Application/ui/components/apz_scaffold.dart';
import 'package:Retail_Application/ui/widgets/account_screen.dart';
import 'package:Retail_Application/ui/widgets/upcoming_payments.dart';
import 'package:Retail_Application/ui/components/apz_footer.dart';
import 'package:Retail_Application/ui/components/apz_header.dart';
import 'package:Retail_Application/ui/components/apz_alert.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// class FooterHeaderScreen extends StatefulWidget {
//   const FooterHeaderScreen({super.key});

//   @override
//   _FooterExampleScreenState createState() => _FooterExampleScreenState();
// }

// class _FooterExampleScreenState extends State<FooterHeaderScreen> {
//   int _selectedIndex = 0;
//   bool _isMenuOpen = false;

//   // Only include pages that are implemented
//   final _pages = [
//     const AccountScreen(),
//   ];

//   void _onItemSelected(int index) {
//     // Tabs that are implemented
//     if (index < _pages.length) {
//       setState(() {
//         _selectedIndex = index;
//       });
//       return;
//     }

//     if (index == 3 || index == 4) {
//       ApzAlert.show(
//         context,
//         title: "Coming Soon",
//         message: "This feature is under development.",
//         messageType: ApzAlertMessageType.info,
//         buttons: ["OK"],
//       );
//     }

//     // You can ignore other indexes or handle them differently if needed
//   }

//   void _toggleMenu() {
//     setState(() {
//       _isMenuOpen = !_isMenuOpen;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       body: Column(
//         children: [
//           SafeArea(
//             child: ApzHeader(
//               hasNotification: true,
//               onSearchTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Search tapped")));
//               },
//               onProfileTap: () {
//                 context.push('/profile'); // Navigate to profile screen
//               },
//             ),
//           ),
//           Expanded(
//             child: Stack(
//               children: [
//                 IndexedStack(
//                   index: _selectedIndex,
//                   children: _pages,
//                 ),
//                 if (_isMenuOpen)
//                   Positioned.fill(
//                     child: GestureDetector(
//                       onTap: _toggleMenu,
//                       child: Container(color: Colors.black.withOpacity(0.5)),
//                     ),
//                   ),
//                 if (_isMenuOpen)
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: MenuSheet(onClose: _toggleMenu),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: FooterBar(
//         selectedIndex: _selectedIndex,
//         onItemSelected: _onItemSelected,
//         onCenterTap: _toggleMenu,
//         isMenuOpen: _isMenuOpen,
//       ),
//     );
//   }
// }
class FooterHeaderScreen extends StatefulWidget {
  const FooterHeaderScreen({super.key});

  @override
  _FooterHeaderScreenState createState() => _FooterHeaderScreenState();
}

class _FooterHeaderScreenState extends State<FooterHeaderScreen> {
  int _selectedIndex = 0;

  // Only include pages that are implemented

  final _pages = [
    const AccountScreen(),

    // Add other implemented pages here
  ];

  void _onItemSelected(int index) {
    // If the page is implemented, switch to it.

    if (index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });

      return;
    }

    // For any other index, show a "Coming Soon" alert.

    // The center button for the menu doesn't call this method.

    if (index == 3 || index == 4) {
      ApzAlert.show(
        context,
        title: "Coming Soon",
        message: "This feature is under development.",
        messageType: ApzAlertMessageType.info,
        buttons: ["OK"],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replace the old Scaffold with the new ApzFooterScaffold

    return ApzFooterScaffold(
      selectedIndex: _selectedIndex,
      onItemSelected: _onItemSelected,
      body: Column(
        children: [
          SafeArea(
            bottom: false, // Avoids padding at the bottom of the safe area

            child: ApzHeader(
              hasNotification: true,
              onSearchTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Search tapped")));
              },
              onProfileTap: () {
                context.push('/profile'); // Navigate to profile screen
              },
              onNotificationTap: () {
                context.push('/Notifications');
              },
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
