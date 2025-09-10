import 'package:flutter/material.dart';
import 'package:Retail_Application/models/menu_model/apz_menu_options.dart';
import 'package:Retail_Application/ui/components/apz_menu_item.dart';

class MenuSheet extends StatelessWidget {
  const MenuSheet({Key? key, required List<MenuOption> options})
      : super(key: key);

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
          );
        },
      ),
    );
  }
}
