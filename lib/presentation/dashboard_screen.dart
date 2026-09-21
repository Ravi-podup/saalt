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
import 'package:saalt/presentation/quiz/fit_quiz_screen.dart';
import 'package:saalt/presentation/tracker/period_tracker_screen.dart';
import 'package:saalt/presentation/show/saalt_show_screen.dart';
import 'package:saalt/presentation/testimonials/testimonials_screen.dart';
import 'package:saalt/presentation/widgets/dashboard_tile.dart';
import 'package:saalt/presentation/widgets/period_tracker_card.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

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

  void _openFitQuiz() {
    FitQuizScreen.open(context);
  }

  void _openItem(DashboardItem item) {
    switch (item.index) {
      case 0:
        CommunityScreen.open(context);
      case 1:
        TestimonialsScreen.open(context);
      case 2:
        ProductsScreen.open(context);
      case 3:
        TmiPartiesScreen.open(context);
      case 4:
        SaaltShowScreen.open(context);
      case 5:
        KnowledgebaseScreen.open(context);
      default:
        _open(item.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hey Maria 👋',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.inkDeep,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'TMI welcome. Actually,\nTMI encouraged',
                            style: TextStyle(
                              fontSize: 24,
                              height: 1.1,
                              fontWeight: FontWeight.w400,
                              color: AppColors.inkDeep,
                            ),
                          ),
                          const SizedBox(height: 16),
                          PeriodTrackerCard(
                            cycleDay: TrackerHelper.cycleDay,
                            cycleLength: TrackerHelper.averageCycle,
                            phaseLabel: TrackerHelper.phase.label,
                            onTap: _openTracker,
                            onLogTap: _openTracker,
                            onFitQuizTap: _openFitQuiz,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: _SectionLabel('Explore Saalt'),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
                    sliver: SliverToBoxAdapter(
                      child: _ExploreGrid(onOpen: _openItem),
                    ),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 5),
      child: Row(
        children: [
          Image.asset(AppImages.logo, height: 26, fit: BoxFit.contain),
          const Spacer(),
          GestureDetector(
            onTap: () => NotificationsScreen.open(context),
            child: Image.asset(
              AppImages.notificationButtonIcon,
              height: 44,
              width: 44,
            ),
          ),

          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => ProfileScreen.open(context),
            child: Image.asset(
              AppImages.profilePictureCircleImage,
              height: 44,
              width: 44,
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
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: AppColors.inkDeep,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: AppColors.lightGray, height: 1)),
        ],
      ),
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  const _ExploreGrid({required this.onOpen});

  final ValueChanged<DashboardItem> onOpen;

  static const _gap = 14.0;

  @override
  Widget build(BuildContext context) {
    final items = DashboardHelper.items;

    return LayoutBuilder(
      builder: (context, box) {
        final tileWidth = (box.maxWidth - _gap) / 2;
        final smallHeight = tileWidth / 1.14;
        final tallHeight = smallHeight * 2 + _gap;

        final groups = <Widget>[];
        for (var start = 0; start < items.length; start += 3) {
          final end = start + 3 <= items.length ? start + 3 : items.length;
          groups.add(
            Padding(
              padding: EdgeInsets.only(top: start == 0 ? 0 : _gap),
              child: _ExploreGroup(
                items: items.sublist(start, end),
                tallOnRight: (start ~/ 3).isEven,
                smallHeight: smallHeight,
                tallHeight: tallHeight,
                onOpen: onOpen,
              ),
            ),
          );
        }

        return Column(children: groups);
      },
    );
  }
}

class _ExploreGroup extends StatelessWidget {
  const _ExploreGroup({
    required this.items,
    required this.tallOnRight,
    required this.smallHeight,
    required this.tallHeight,
    required this.onOpen,
  });

  final List<DashboardItem> items;

  final bool tallOnRight;
  final double smallHeight;
  final double tallHeight;
  final ValueChanged<DashboardItem> onOpen;

  Widget _tile(DashboardItem item, double height, {bool isTall = false}) =>
      SizedBox(
        height: height,
        child: DashboardTile(item: item, onTap: () => onOpen(item)),
      );

  @override
  Widget build(BuildContext context) {
    if (items.length < 3) {
      return Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: _ExploreGrid._gap),
            Expanded(child: _tile(items[i], smallHeight)),
          ],
          if (items.length == 1) const Spacer(),
        ],
      );
    }

    final stacked = Column(
      children: [
        Expanded(child: _tile(items[0], smallHeight)),
        const SizedBox(height: _ExploreGrid._gap),
        Expanded(child: _tile(items[1], smallHeight)),
      ],
    );
    final tall = _tile(items[2], tallHeight, isTall: true);

    return SizedBox(
      height: tallHeight,
      child: Row(
        children: [
          Expanded(child: tallOnRight ? stacked : tall),
          const SizedBox(width: _ExploreGrid._gap),
          Expanded(child: tallOnRight ? tall : stacked),
        ],
      ),
    );
  }
}
