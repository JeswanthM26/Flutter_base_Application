import 'package:Retail_Application/ui/components/apz_footer.dart';

import 'package:Retail_Application/ui/widgets/menu_screen.dart';

import 'package:flutter/material.dart';

class ApzFooterScaffold extends StatefulWidget {
  final Widget body;

  final int selectedIndex;

  final ValueChanged<int> onItemSelected;

  const ApzFooterScaffold({
    Key? key,
    required this.body,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _ApzFooterScaffoldState createState() => _ApzFooterScaffoldState();
}

class _ApzFooterScaffoldState extends State<ApzFooterScaffold> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final menuHeight =
        screenHeight * 0.65; // Corresponds to menuSheetHeightFactor

    final footerHeight = 90.0; // Corresponds to footer_height

    return Scaffold(
      body: Stack(
        children: [
          // Main content

          widget.body,

          // Overlay to detect tap outside of menu

          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),

          // The menu sheet

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isMenuOpen ? 0 : -menuHeight,
            left: 0,
            right: 0,
            child: MenuSheet(onClose: _toggleMenu),
          ),
        ],
      ),
      bottomNavigationBar: FooterBar(
        selectedIndex: widget.selectedIndex,
        onItemSelected: (index) {
          _closeMenu();

          widget.onItemSelected(index);
        },
        onCenterTap: _toggleMenu,
        isMenuOpen: _isMenuOpen,
      ),
    );
  }
}
