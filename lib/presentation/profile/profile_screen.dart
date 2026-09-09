import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/shop_demo.dart';
import 'package:saalt/presentation/products/cart_screen.dart';
import 'package:saalt/presentation/products/orders_screen.dart';
import 'package:saalt/presentation/products/wishlist_screen.dart';
import 'package:saalt/presentation/tracker/tracker_settings_screen.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.profileScreen);
  }

  /// The same person the checkout ships to, so the app reads as one account.
  static String get name => ShopDemo.address.name;
  static const email = 'giorgia.meloni@example.com';
  static const memberSince = 'Member since Mar 2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(title: 'Profile', onBack: () => context.pop()),
            Expanded(
              child: ListView(
                key: const Key('profile-body'),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  const _Identity(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _Stat(
                        value: '${ShopDemo.orders.length}',
                        label: 'Orders',
                        accent: AppColors.rose,
                        onTap: () => OrdersScreen.open(context),
                      ),
                      const SizedBox(width: 10),
                      _Stat(
                        value: '${ShopDemo.saved.length}',
                        label: 'Saved',
                        accent: AppColors.periwinkle,
                        onTap: () => WishlistScreen.open(context),
                      ),
                      const SizedBox(width: 10),
                      _Stat(
                        value: '${ShopDemo.cartCount}',
                        label: 'In cart',
                        accent: AppColors.teal,
                        onTap: () => CartScreen.open(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _Group(
                    title: 'Shop',
                    rows: [
                      _Row(
                        icon: Icons.receipt_long_outlined,
                        label: 'Your orders',
                        onTap: () => OrdersScreen.open(context),
                      ),
                      _Row(
                        icon: Icons.favorite_border_rounded,
                        label: 'Favorites',
                        onTap: () => WishlistScreen.open(context),
                      ),
                      _Row(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Your cart',
                        onTap: () => CartScreen.open(context),
                      ),
                      const _Row(
                        icon: Icons.location_on_outlined,
                        label: 'Addresses',
                        value: '1 saved',
                      ),
                      const _Row(
                        icon: Icons.credit_card_rounded,
                        label: 'Payment methods',
                        value: 'Card · 4242',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _Group(
                    title: 'Your cycle',
                    rows: [
                      _Row(
                        icon: Icons.tune_rounded,
                        label: 'Tracker settings',
                        onTap: () => TrackerSettingsScreen.open(context),
                      ),
                      const _Row(
                        icon: Icons.notifications_none_rounded,
                        label: 'Reminders',
                        value: 'Period due',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _Group(
                    title: 'App',
                    rows: [
                      _Row(
                        icon: Icons.translate_rounded,
                        label: 'Language',
                        value: 'English',
                      ),
                      _Row(
                        icon: Icons.help_outline_rounded,
                        label: 'Help & support',
                      ),
                      _Row(
                        icon: Icons.description_outlined,
                        label: 'Terms & privacy',
                      ),
                      _Row(
                        icon: Icons.info_outline_rounded,
                        label: 'About Saalt',
                        value: 'v1.0.0',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SignOut(
                    // go, not push: signing out should not leave the app
                    // sitting underneath the login screen.
                    onTap: () => context.go(AppRoutePaths.loginScreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity();

  String get _initials => ProfileScreen.name
      .trim()
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.roseTint,
              shape: BoxShape.circle,
            ),
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: AppColors.rose,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ProfileScreen.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  ProfileScreen.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
                ),
                const SizedBox(height: 6),
                const Text(
                  ProfileScreen.memberSince,
                  style: TextStyle(fontSize: 10.5, color: AppColors.inkFaint),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.canvas,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {},
              customBorder: const CircleBorder(),
              child: const SizedBox(
                height: 34,
                width: 34,
                child: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final String value;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
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

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 9),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: AppColors.inkFaint,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0)
                  const Padding(
                    padding: EdgeInsets.only(left: 52),
                    child: Divider(color: AppColors.hairline, height: 1),
                  ),
                rows[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, this.value, this.onTap});

  final IconData icon;
  final String label;

  /// Shown on the right, for rows that state something.
  final String? value;

  /// Null leaves the row display only, and it keeps no chevron so it does
  /// not promise a screen that is not there.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.inkMuted),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: 8),
                Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
              if (onTap != null) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 19,
                  color: AppColors.inkFaint,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SignOut extends StatelessWidget {
  const _SignOut({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: AppColors.hairline),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, size: 16, color: AppColors.rose),
                SizedBox(width: 8),
                Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.rose,
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
