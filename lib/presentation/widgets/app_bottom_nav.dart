import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// One tab in [AppBottomNav].
class BottomNavItem {
  const BottomNavItem({
    required this.label,
    this.icon,
    this.asset,
    this.customIcon,
    this.badgeCount = 0,
    this.onTap,
  });

  final String label;
  final IconData? icon;

  /// Drawn instead of [icon]. The glyphs are solid, so they take the tab's
  /// colour the same way a Material icon would.
  final String? asset;

  /// Null leaves the tab presentational, which most of them are: the bars
  /// mark where you already are rather than routing anywhere.
  final VoidCallback? onTap;

  /// Drawn instead of [icon] when the tab needs its own artwork, such as the
  /// wordmark. Keeps its own colour rather than taking the active tint.
  final Widget? customIcon;

  final int badgeCount;

  /// The shared Home tab, carrying the wordmark in place of an icon. Defined
  /// once so every bar's Home reads identically.
  static BottomNavItem home() => BottomNavItem(
    label: 'Home',
    customIcon: Image.asset(AppImages.logo, height: 15, fit: BoxFit.contain),
  );

  /// The five tabs the Collective runs, in order.
  static const collective = <BottomNavItem>[
    BottomNavItem(label: 'Saalt', asset: AppImages.homeNavIcon),
    BottomNavItem(label: 'Groups', asset: AppImages.groupNavIcon),
    BottomNavItem(label: 'Chat', asset: AppImages.chatNavIcon),
    BottomNavItem(label: 'Events', asset: AppImages.eventNavIcon),
    BottomNavItem(label: 'You', asset: AppImages.profileNavIcon),
  ];

  /// The same bar for the Saalt Show: only the marks and the words change.
  static const show = <BottomNavItem>[
    BottomNavItem(label: 'Saalt', asset: AppImages.homeNavIcon),
    BottomNavItem(label: 'Episodes', asset: AppImages.episodesNavIcon),
    BottomNavItem(label: 'Shop', asset: AppImages.shopNavIcon),
    BottomNavItem(label: 'Blog', asset: AppImages.blogNavIcon),
    BottomNavItem(label: 'About', asset: AppImages.aboutNavIcon),
  ];
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.items, required this.selected});

  /// The tints the bar is drawn with.
  static const _activeInk = Color(0xFFC95878);
  static const _activeGround = Color(0xFFF6E4E4);
  static const _restingInk = Color(0xFF9CA3AF);
  static const _topEdge = Color(0xFFF3F4F6);

  final List<BottomNavItem> items;

  /// Label of the tab shown as current.
  final String selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: _topEdge)),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: [
              for (final item in items)
                _NavItem(item: item, isActive: item.label == selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.item, required this.isActive});

  final BottomNavItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppBottomNav._activeInk : AppBottomNav._restingInk;
    final asset = item.asset;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isActive,
        child: InkWell(
          onTap: item.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isActive ? AppBottomNav._activeGround : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 22,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      if (item.customIcon != null)
                        item.customIcon!
                      else if (asset != null)
                        Image.asset(
                          asset,
                          height:
                              item.label == 'Saalt' || item.label == 'Underwear'
                              ? 15
                              : item.label == 'You' ||
                                    item.label == 'Events' ||
                                    item.label == "Bundles" ||
                                    item.label == "Cleaning" ||
                                    item.label == "Teen"
                              ? 22
                              : 18,
                          color: color,
                          errorBuilder: (_, _, _) =>
                              Icon(item.icon, size: 21, color: color),
                        )
                      else
                      // Icon(item.icon, size: 21, color: color),
                      if (item.badgeCount > 0)
                        Positioned(
                          top: -3,
                          right: -9,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(minWidth: 16),
                            height: 16,
                            decoration: BoxDecoration(
                              color: Color(0xffF6E4E4),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.surface,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${item.badgeCount}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
