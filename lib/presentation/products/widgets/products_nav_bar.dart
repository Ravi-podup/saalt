import 'package:flutter/material.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';

/// Bottom bar for the shop: home, the two headline categories, and the bag.
class ProductsNavBar extends StatelessWidget {
  const ProductsNavBar({super.key, this.selected = 'Home'});

  final String selected;

  @override
  Widget build(BuildContext context) {
    return AppBottomNav(
      selected: selected,
      items: [
        BottomNavItem.home(),
        const BottomNavItem(label: 'Underwear', icon: Icons.checkroom_rounded),
        const BottomNavItem(label: 'Cups', icon: Icons.water_drop_rounded),
        const BottomNavItem(label: 'Bags', icon: Icons.shopping_bag_outlined),
      ],
    );
  }
}
