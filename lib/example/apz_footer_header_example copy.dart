// import 'package:Retail_Application/example/appz_button_example.dart';
// import 'package:Retail_Application/example/appz_radio_example.dart';
// import 'package:Retail_Application/example/apz_dropdown_example.dart';
// import 'package:Retail_Application/example/apz_searchbar_example.dart';
// import 'package:Retail_Application/themes/apz_theme_provider.dart';
// import 'package:Retail_Application/ui/components/apz_scaffold.dart';
// import 'package:Retail_Application/ui/widgets/account_screen.dart';
// import 'package:Retail_Application/ui/widgets/menu_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/ui/components/apz_footer.dart';
// import 'package:Retail_Application/ui/components/apz_header.dart';
// import 'package:provider/provider.dart';

// class FooterHeaderScreen extends StatefulWidget {
//   const FooterHeaderScreen({super.key});
//   @override
//   _FooterExampleScreenState createState() => _FooterExampleScreenState();
// }

// class _FooterExampleScreenState extends State<FooterHeaderScreen> {
//   int _selectedIndex = 0;

//   final _pages = [
//     const AccountScreen(),
//     const AppzRadioExample(),
      
//     MenuSheet(options: const [],),
//     const AppzButtonExample(),
//     const ApzDropdownExample(),
//   ];

//   void _onItemSelected(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       body: Column(
//         children: [
//           SafeArea(
//             child:

//                 /// ✅ Header stays on top
//                 ApzHeader(
//               hasNotification: true,
//               onSearchTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Search tapped")),
//                 );
//               },
//               onNotificationTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Notifications tapped")),
//                 );
//               },
//               onProfileTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Profile tapped")),
//                 );
//               },
//             ),
//           ),

//           /// ✅ Page content below header
//           Expanded(
//             child: IndexedStack(
//               index: _selectedIndex,
//               children: _pages,
//             ),
//           ),
//         ],
//       ),

//       /// ✅ Footer stays fixed at bottom
//       bottomNavigationBar: FooterBar(
//         selectedIndex: _selectedIndex,
//         onItemSelected: _onItemSelected,
//         onCenterTap: () {},
//       ),
//       //  floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
//       //   },
//       //  child: const Icon(Icons.brightness_6),
//       // ),
//     );
//   }
// }


import 'package:Retail_Application/example/appz_button_example.dart';
import 'package:Retail_Application/example/appz_radio_example.dart';
import 'package:Retail_Application/example/apz_dropdown_example.dart';
import 'package:Retail_Application/themes/apz_theme_provider.dart';
import 'package:Retail_Application/ui/components/apz_scaffold.dart';
import 'package:Retail_Application/ui/widgets/account_screen.dart';
import 'package:Retail_Application/ui/widgets/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/ui/components/apz_footer.dart';
import 'package:Retail_Application/ui/components/apz_header.dart';
import 'package:provider/provider.dart';

class FooterHeaderScreen extends StatefulWidget {
  const FooterHeaderScreen({super.key});
  @override
  _FooterHeaderScreenState createState() => _FooterHeaderScreenState();
}
class _FooterHeaderScreenState extends State<FooterHeaderScreen> {
  int _selectedIndex = 0;
  bool _isMenuOpen = false; // This is new: to track if the menu is open

  // The pages corresponding to the footer tabs.
  // Note: The center item in the footer doesn't have a page, 
  // so we have a placeholder here.
  final _pages = [
    const ApzDropdownExample(),
    const AppzRadioExample(),
    const MenuSheet(options: [],), // Placeholder for the center item
    const AppzButtonExample(),
    const ApzDropdownExample(),
  ];
  void _onItemSelected(int index) {
    // This logic is updated to prevent changing pages when the menu is open
    if (_isMenuOpen) return; 
    setState(() {
      _selectedIndex = index;
    });
  }

  // This is the new function that opens and closes the menu
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
                  const SnackBar(content: Text("Search tapped")),
                );
              },
              onNotificationTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notifications tapped")),
                );
              },
              onProfileTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile tapped")),
                );
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
      // NEW: This line shows the MenuSheet widget when the menu is open.
      bottomSheet: _isMenuOpen ? const MenuSheet(options: [],) : null,
      
      // UPDATED: The FooterBar is now connected to our new state and functions.
      bottomNavigationBar: FooterBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onCenterTap: _toggleMenu, 
        isMenuOpen: _isMenuOpen,
      ),
    );
  }
}