// import 'package:Retail_Application/example/appz_button_example.dart';
// import 'package:Retail_Application/example/appz_radio_example.dart';
// import 'package:Retail_Application/example/apz_dropdown_example.dart';
// import 'package:Retail_Application/example/apz_searchbar_example.dart';
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/ui/components/apz_footer.dart';
 
// class FooterExampleScreen extends StatefulWidget {
//   const FooterExampleScreen({super.key});
//   @override
//   _FooterExampleScreenState createState() => _FooterExampleScreenState();
// }
 
// class _FooterExampleScreenState extends State<FooterExampleScreen> {
//   int _selectedIndex = 0;
 
//   final _pages = const [
//     ApzDropdownExample(),
//     AppzRadioExample(),
//     SearchBarDemoPage(),
//     AppzButtonExample(),
//     ApzDropdownExample(),
//   ];
 
//   void _onItemSelected(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // ✅ Use IndexedStack so pages keep state when switching
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: FooterBar(
//         selectedIndex: _selectedIndex,
//         onItemSelected: _onItemSelected,
//         onCenterTap: () {  },
//       ),
//     );
//   }
// }
 
 import 'package:Retail_Application/example/appz_button_example.dart';
import 'package:Retail_Application/example/appz_radio_example.dart';
import 'package:Retail_Application/example/apz_dropdown_example.dart';
import 'package:Retail_Application/example/apz_searchbar_example.dart';
import 'package:Retail_Application/ui/widgets/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/ui/components/apz_footer.dart';
 
class FooterExampleScreen extends StatefulWidget {
  const FooterExampleScreen({super.key});
  @override
  _FooterExampleScreenState createState() => _FooterExampleScreenState();
}
 
class _FooterExampleScreenState extends State<FooterExampleScreen> {
  int _selectedIndex = 0;
  bool _isMenuOpen = false;

  final _pages = const [
    ApzDropdownExample(),
    AppzRadioExample(),
    SearchBarDemoPage(),
    AppzButtonExample(),
    ApzDropdownExample(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Use IndexedStack so pages keep state when switching
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomSheet: _isMenuOpen ? const MenuSheet(options: [],) : null,
      bottomNavigationBar: FooterBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onCenterTap: _toggleMenu,
        isMenuOpen: _isMenuOpen,
      ),
    );
  }
}
 
 