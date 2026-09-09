import 'package:flutter/material.dart';
import 'package:saalt/helper/dashboard_helper.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/models/dashboard_item.dart';
import 'package:saalt/helper/notification_demo.dart';
import 'package:saalt/presentation/notifications/notifications_screen.dart';
import 'package:saalt/presentation/profile/profile_screen.dart';
import 'package:saalt/presentation/community/community_screen.dart';
import 'package:saalt/presentation/knowledgebase/knowledgebase_screen.dart';
import 'package:saalt/presentation/parties/tmi_parties_screen.dart';
import 'package:saalt/presentation/products/products_screen.dart';
import 'package:saalt/presentation/tracker/period_tracker_screen.dart';
import 'package:saalt/presentation/show/saalt_show_screen.dart';
import 'package:saalt/presentation/testimonials/testimonials_screen.dart';
import 'package:saalt/presentation/widgets/dashboard_tile.dart';
import 'package:saalt/presentation/widgets/period_tracker_card.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.dashboardScreen);
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _open(String name) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$name coming up'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _openTracker() {
    PeriodTrackerScreen.open(context);
  }

  void _openItem(DashboardItem item) {
    switch (item.title) {
      case 'Products':
        ProductsScreen.open(context);
      case 'Knowledgebase':
        KnowledgebaseScreen.open(context);
      case 'Saalt Show':
        SaaltShowScreen.open(context);
      case 'Testimonials':
        TestimonialsScreen.open(context);
      case 'Community':
        CommunityScreen.open(context);
      case 'TMI Parties':
        TmiPartiesScreen.open(context);
      default:
        _open(item.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          const _BackdropWash(),
          SafeArea(
            child: Column(
              children: [
                const _Header(),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                          child: PeriodTrackerCard(
                            cycleDay: TrackerHelper.cycleDay,
                            cycleLength: TrackerHelper.averageCycle,
                            phaseLabel: TrackerHelper.phase.label,
                            onTap: _openTracker,
                            onLogTap: _openTracker,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: _SectionLabel('Explore')),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 1.14,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = DashboardHelper.items[index];
                            return DashboardTile(
                              item: item,
                              onTap: () => _openItem(item),
                            );
                          }, childCount: DashboardHelper.items.length),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropWash extends StatelessWidget {
  const _BackdropWash();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -110,
              right: -70,
              child: _Bloom(color: AppColors.roseTint, size: 260),
            ),
            Positioned(
              top: 180,
              left: -100,
              child: _Bloom(color: AppColors.periwinkleTint, size: 220),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bloom extends StatelessWidget {
  const _Bloom({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.75), color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppImages.logo, height: 26, fit: BoxFit.contain),
              const Spacer(),
              // The shared button, so these two carry labels and match every
              // other header in the app.
              CircleIconButton(
                icon: Icons.notifications_none_rounded,
                tooltip: 'Notifications',
                showDot: NotificationDemo.unreadCount > 0,
                onTap: () => NotificationsScreen.open(context),
              ),
              const SizedBox(width: 10),
              CircleIconButton(
                icon: Icons.person_outline_rounded,
                tooltip: 'Profile',
                onTap: () => ProfileScreen.open(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Hey there 👋',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              color: AppColors.inkMuted.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Everything you need,\nall in one place.',
            style: TextStyle(
              fontSize: 24,
              height: 1.25,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: AppColors.hairline, height: 1)),
        ],
      ),
    );
  }
}
