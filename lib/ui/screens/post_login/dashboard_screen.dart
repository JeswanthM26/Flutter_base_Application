import 'package:Retail_Application/example/appz_button_example.dart';

import 'package:Retail_Application/example/appz_radio_example.dart';

import 'package:Retail_Application/example/apz_dropdown_example.dart';

import 'package:Retail_Application/example/apz_searchbar_example.dart';

import 'package:Retail_Application/themes/apz_theme_provider.dart';
<<<<<<< HEAD
import 'package:Retail_Application/ui/widgets/menu_screen.dart';
=======
import 'package:Retail_Application/ui/widgets/account_dashoard.dart';

import 'package:Retail_Application/ui/widgets/favourite_transactions.dart';

import 'package:Retail_Application/ui/widgets/menu_screen.dart';

>>>>>>> 8640d825809d5f522af9a57075ec5fb5feeff189
import 'package:Retail_Application/ui/components/apz_scaffold.dart';

import 'package:Retail_Application/ui/widgets/account_screen.dart';

import 'package:Retail_Application/ui/widgets/upcoming_payments.dart';

import 'package:Retail_Application/ui/components/apz_footer.dart';

import 'package:Retail_Application/ui/components/apz_header.dart';

import 'package:Retail_Application/ui/components/apz_alert.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class FooterHeaderScreen extends StatefulWidget {
  const FooterHeaderScreen({super.key});

  @override
  _FooterExampleScreenState createState() => _FooterExampleScreenState();
}

class _FooterExampleScreenState extends State<FooterHeaderScreen> {
  int _selectedIndex = 0;
    bool _isMenuOpen = false;


  bool _isMenuOpen = false;

  // Only include pages that are implemented

  final _pages = [
    const AccountScreen(),
<<<<<<< HEAD
    const UpcomingPaymentsCardWidget(),
   const AppzRadioExample(),
    const AppzButtonExample(),
    const ApzDropdownExample(),
=======
    const AccountDashboard(),
>>>>>>> 8640d825809d5f522af9a57075ec5fb5feeff189
  ];

  void _onItemSelected(int index) {
    // Tabs that are implemented

    if (index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });

      return;
    }

    // Tabs that are under development

    String featureName;

    switch (index) {
      case 2:
        featureName = "Appz Radio";

        break;

      case 3:
        featureName = "Appz Button";

        break;

      case 4:
        featureName = "Appz Dropdown";

        break;

      default:
        featureName = "This feature";
    }

    ApzAlert.show(
      context,
      title: "Coming Soon",
      message: "This feature is under development.",
      messageType: ApzAlertMessageType.info,
      buttons: ["OK"],
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }
  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          SafeArea(
            child: ApzHeader(
              hasNotification: true,
              onSearchTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Search tapped")));
              },
              // onNotificationTap: () {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text("Notifications tapped")));
              // },
              onProfileTap: () {
                context.push('/profile'); // 👈 set your route path here
              },
            ),
          ),
<<<<<<< HEAD
 Expanded(
=======
          Expanded(
>>>>>>> 8640d825809d5f522af9a57075ec5fb5feeff189
            child: Stack(
              children: [
                IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
                if (_isMenuOpen)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _toggleMenu,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                if (_isMenuOpen)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MenuSheet(onClose: _toggleMenu),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: FooterBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onCenterTap: _toggleMenu,
        isMenuOpen: _isMenuOpen,
      ),
<<<<<<< HEAD
          /// ✅ Page content below header
      //     Expanded(
      //       child: IndexedStack(
      //         index: _selectedIndex,
      //         children: _pages,
      //       ),
      //     ),
      //   ],
      // ),

      // /// ✅ Footer stays fixed at bottom
      // bottomNavigationBar: FooterBar(
      //   selectedIndex: _selectedIndex,
      //   onItemSelected: _onItemSelected,
      //   onCenterTap: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       backgroundColor: Colors.transparent,
      //       builder: (context) => const MenuSheet(),
      //     );
      //   },
      //  floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      //   },
      //  child: const Icon(Icons.brightness_6),
      // ),
    
=======
>>>>>>> 8640d825809d5f522af9a57075ec5fb5feeff189
    );
  }
}



