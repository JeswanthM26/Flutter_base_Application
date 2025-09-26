import 'package:retail_application/example/appz_button_example.dart';
import 'package:retail_application/example/appz_radio_example.dart';
import 'package:retail_application/example/apz_dropdown_example.dart';
import 'package:retail_application/example/apz_searchbar_example.dart';
import 'package:retail_application/themes/apz_theme_provider.dart';
import 'package:retail_application/ui/components/apz_scaffold.dart';
import 'package:retail_application/ui/widgets/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/ui/components/apz_footer.dart';
import 'package:retail_application/ui/components/apz_header.dart';
import 'package:provider/provider.dart';
import 'package:retail_application/ui/widgets/menu_screen.dart';

class FooterHeaderScreen extends StatefulWidget {
  const FooterHeaderScreen({super.key});
  @override
  _FooterExampleScreenState createState() => _FooterExampleScreenState();
}

class _FooterExampleScreenState extends State<FooterHeaderScreen> {
  int _selectedIndex = 0;

  final _pages = [
    const AccountScreen(),
    const AppzRadioExample(),
    // MenuSheet(
    //   options: const [],
    // ),
    const AppzButtonExample(),
    const ApzDropdownExample(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          SafeArea(
            child:

                /// ✅ Header stays on top
                ApzHeader(
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

          /// ✅ Page content below header
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),

      /// ✅ Footer stays fixed at bottom
      bottomNavigationBar: FooterBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onCenterTap: () {},
      ),
      //  floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      //   },
      //  child: const Icon(Icons.brightness_6),
      // ),
    );
  }
}
