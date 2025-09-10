import 'package:flutter/material.dart';
import 'package:Retail_Application/ui/components/apz_footer.dart'; // 👈 your footer component
import 'package:Retail_Application/ui/components/apz_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("🏠 Home Page")),
    const Center(child: Text("👤 Accounts Page")),
    const Center(child: Text("⚡ Menu Placeholder")), // replaced by MenuSheet
    const Center(child: Text("💳 Cards Page")),
    const Center(child: Text("📊 Spends Page")),
  ];

  void _onItemSelected(int index) {
    if (index == 2) {
      // 👇 Open MenuSheet instead of switching page
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const MenuSheet(
          options: [],
        ),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ base background
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: FooterBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onCenterTap: () {},
      ),
    );
  }
}
