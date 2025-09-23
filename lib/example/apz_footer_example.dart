import 'package:retail_application/example/appz_button_example.dart';
import 'package:retail_application/example/appz_radio_example.dart';
import 'package:retail_application/example/apz_dropdown_example.dart';
import 'package:retail_application/example/apz_searchbar_example.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/ui/components/apz_footer.dart';
 
class FooterExampleScreen extends StatefulWidget {
  const FooterExampleScreen({super.key});
  @override
  _FooterExampleScreenState createState() => _FooterExampleScreenState();
}
 
class _FooterExampleScreenState extends State<FooterExampleScreen> {
  int _selectedIndex = 0;
 
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
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Use IndexedStack so pages keep state when switching
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: FooterBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onCenterTap: () {  },
      ),
    );
  }
}
 
 