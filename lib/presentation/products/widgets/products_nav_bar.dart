import 'package:flutter/material.dart';
import 'package:saalt/helper/cart_store.dart';
import 'package:saalt/presentation/products/cart_screen.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';

/// Bottom bar for the shop: home, the two headline categories, and the cart.
///
/// Only the cart tab routes. The categories are presentational, as they have
/// been since the bar went in — the shop already filters from its own chips.
class ProductsNavBar extends StatelessWidget {
  const ProductsNavBar({super.key, this.selected = 'Home'});

  final String selected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: CartStore.items,
      builder: (context, _, _) => AppBottomNav(
        selected: selected,
        items: [
          BottomNavItem.home(),
          const BottomNavItem(
            label: 'Underwear',
            icon: Icons.checkroom_rounded,
          ),
          const BottomNavItem(
            label: 'Cups & Discs',
            icon: Icons.water_drop_rounded,
          ),
          BottomNavItem(
            label: 'Cart',
            icon: Icons.shopping_bag_outlined,
            badgeCount: CartStore.count,
            onTap: () => CartScreen.open(context),
          ),
        ],
      ),
    );
  }
}
