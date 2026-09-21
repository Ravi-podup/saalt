import 'package:flutter/material.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';
import 'package:saalt/res/app_images.dart';

/// The shop's tab bar: the five things the catalogue is divided into. Same
/// bar as the Collective and the Show; only the marks and the words change.
class ProductsNavBar extends StatelessWidget {
  const ProductsNavBar({super.key, this.selected = 'Underwear'});

  final String selected;

  /// In catalogue order, the way the category strip lists them.
  static const items = <BottomNavItem>[
    BottomNavItem(label: 'Underwear', asset: AppImages.underwearNavIcon),
    BottomNavItem(label: 'Cups & Discs', asset: AppImages.cupDiscNavIcon),
    BottomNavItem(label: 'Teen', asset: AppImages.teenNavIcon),
    BottomNavItem(label: 'Cleaning', asset: AppImages.clearingNavIcon),
    BottomNavItem(label: 'Bundles', asset: AppImages.bundleNavIcon),
  ];

  @override
  Widget build(BuildContext context) {
    return AppBottomNav(selected: selected, items: items);
  }
}
