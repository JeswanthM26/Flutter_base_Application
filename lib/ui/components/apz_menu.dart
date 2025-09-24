import 'package:flutter/material.dart';
import 'package:retail_application/models/menu_model/apz_menu_options.dart';
import 'package:retail_application/ui/components/apz_menu_item.dart';

class MenuSheet extends StatefulWidget {
  const MenuSheet({Key? key, required this.options}) : super(key: key);
  final List<MenuOption> options;

  @override
  _MenuSheetState createState() => _MenuSheetState();
}

class _MenuSheetState extends State<MenuSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<MenuOption> _getMenuOptions(BuildContext context) {
    return [
      MenuOption(
        label: 'Promotions',
        icon: Icons.local_offer_outlined,
        onTap: () {
          Navigator.pop(context);
          // your logic
        },
      ),
      MenuOption(
        label: 'Payments',
        icon: Icons.payment,
        onTap: () {},
      ),
      MenuOption(
        label: 'Rewards',
        icon: Icons.card_giftcard,
        onTap: () {},
      ),
      MenuOption(
        label: 'Transfers',
        icon: Icons.swap_horiz,
        onTap: () {},
      ),
      MenuOption(
        label: 'Settings',
        icon: Icons.settings,
        onTap: () {},
      ),
      MenuOption(
        label: 'Payments',
        icon: Icons.payment,
        onTap: () {},
      ),
      MenuOption(
        label: 'Rewards',
        icon: Icons.card_giftcard,
        onTap: () {},
      ),
      MenuOption(
        label: 'Transfers',
        icon: Icons.swap_horiz,
        onTap: () {},
      ),
      MenuOption(
        label: 'Settings',
        icon: Icons.settings,
        onTap: () {},
      ),
      MenuOption(
        label: 'Payments',
        icon: Icons.payment,
        onTap: () {},
      ),
      MenuOption(
        label: 'Rewards',
        icon: Icons.card_giftcard,
        onTap: () {},
      ),
      MenuOption(
        label: 'Transfers',
        icon: Icons.swap_horiz,
        onTap: () {},
      ),
      MenuOption(
        label: 'Settings',
        icon: Icons.settings,
        onTap: () {},
      ),
      MenuOption(
        label: 'Rewards',
        icon: Icons.card_giftcard,
        onTap: () {},
      ),
      MenuOption(
        label: 'Transfers',
        icon: Icons.swap_horiz,
        onTap: () {},
      ),
      MenuOption(
        label: 'Settings',
        icon: Icons.settings,
        onTap: () {},
      ),
      MenuOption(
        label: 'Payments',
        icon: Icons.payment,
        onTap: () {},
      ),
      MenuOption(
        label: 'Rewards',
        icon: Icons.card_giftcard,
        onTap: () {},
      ),
      MenuOption(
        label: 'Rewards',
        icon: Icons.card_giftcard,
        onTap: () {},
      ),
      MenuOption(
        label: 'Transfers',
        icon: Icons.swap_horiz,
        onTap: () {},
      ),
      MenuOption(
        label: 'Settings',
        icon: Icons.settings,
        onTap: () {},
      ),
      MenuOption(
        label: 'Payments',
        icon: Icons.payment,
        onTap: () {},
      ),
      MenuOption(
        label: 'Rewards',
        icon: Icons.card_giftcard,
        onTap: () {},
      ),
      MenuOption(label: 'Theme', icon: Icons.settings, onTap: () {})
      // 👉 add as many as you want
    ];
  }

  @override
  Widget build(BuildContext context) {
    final options = _getMenuOptions(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return MenuItemCard(
            label: option.label,
            icon: option.icon,
            onTap: option.onTap,
            backgroundColor: null,
            contentColor: null,
          );
        },
      ),
    );
  }
}
