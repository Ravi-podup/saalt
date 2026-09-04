import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// One tab in [AppBottomNav].
class BottomNavItem {
  const BottomNavItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.badgeCount = 0,
  });

  final String label;
  final IconData? icon;

  /// Drawn instead of [icon] when the tab needs its own artwork, such as the
  /// wordmark. Keeps its own colour rather than taking the active tint.
  final Widget? customIcon;

  final int badgeCount;

  /// The shared Home tab, carrying the wordmark in place of an icon. Defined
  /// once so every bar's Home reads identically.
  static BottomNavItem home() => BottomNavItem(
    label: 'Home',
    customIcon: Image.asset(AppImages.logo, height: 18, fit: BoxFit.contain),
  );
}

/// Shared bottom tab bar. Presentational: tabs mark which one reads as current
/// but do not route anywhere yet.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.items, required this.selected});

  final List<BottomNavItem> items;

  /// Label of the tab shown as current.
  final String selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F3F4759),
            blurRadius: 16,
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
    final color = isActive ? AppColors.ink : AppColors.inkFaint;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isActive,
        child: Container(
          decoration: BoxDecoration(
            // A wordmark cannot take a tint, so the current tab is marked with
            // a soft pill rather than by icon colour alone.
            color: isActive ? AppColors.roseTint : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 22,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    item.customIcon ?? Icon(item.icon, size: 21, color: color),
                    if (item.badgeCount > 0)
                      Positioned(
                        top: -3,
                        right: -9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(minWidth: 16),
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.rose,
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
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
