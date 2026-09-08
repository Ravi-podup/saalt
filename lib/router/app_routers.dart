import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/models/knowledge_section.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/models/shop_category.dart';
import 'package:saalt/models/webinar_draft.dart';
import 'package:saalt/presentation/auth/login_screen.dart';
import 'package:saalt/presentation/auth/sign_up_screen.dart';
import 'package:saalt/presentation/community/community_screen.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/knowledgebase/knowledge_section_screen.dart';
import 'package:saalt/presentation/knowledgebase/knowledgebase_screen.dart';
import 'package:saalt/presentation/parties/tmi_parties_screen.dart';
import 'package:saalt/presentation/parties/wizard/brief_screen.dart';
import 'package:saalt/presentation/parties/wizard/webinar_wizard_screen.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/products/product_listing_screen.dart';
import 'package:saalt/presentation/products/products_screen.dart';
import 'package:saalt/presentation/show/saalt_show_screen.dart';
import 'package:saalt/presentation/splash_screen.dart';
import 'package:saalt/presentation/testimonials/testimonials_screen.dart';
import 'package:saalt/presentation/tracker/day_detail_screen.dart';
import 'package:saalt/presentation/tracker/period_tracker_screen.dart';
import 'package:saalt/presentation/tracker/tracker_settings_screen.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';
import 'package:saalt/router/app_route_paths.dart';
import 'package:saalt/router/app_transition.dart';

class AppRouters {
  /// main Navigation Router
  static final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  static String _initialRouteLocation({required bool hasToken}) {
    return AppRoutePaths.splashScreen;
  }

  /// Every route in the app. Exposed so a test can host one screen and still
  /// push the rest, rather than each test rebuilding the table.
  static List<RouteBase> get routes => <RouteBase>[
    /// ---------------- Bootstrap ----------------
    GoRoute(
      path: AppRoutePaths.splashScreen,
      pageBuilder: (context, state) =>
          AppTransitions.buildPage(state: state, child: const SplashScreen()),
    ),
    GoRoute(
      path: AppRoutePaths.dashboardScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const DashboardScreen(),
      ),
    ),

    /// ---------------- Auth ----------------
    GoRoute(
      path: AppRoutePaths.loginScreen,
      pageBuilder: (context, state) =>
          AppTransitions.buildPage(state: state, child: const LoginScreen()),
    ),
    GoRoute(
      path: AppRoutePaths.signupScreen,
      pageBuilder: (context, state) =>
          AppTransitions.buildPage(state: state, child: const SignUpScreen()),
    ),

    /// ---------------- Shop ----------------
    GoRoute(
      path: AppRoutePaths.productsScreen,
      pageBuilder: (context, state) =>
          AppTransitions.buildPage(state: state, child: const ProductsScreen()),
    ),
    GoRoute(
      path: AppRoutePaths.productListingScreen,
      pageBuilder: (context, state) {
        final argument = state.extra as Map<String, dynamic>?;
        return AppTransitions.buildPage(
          state: state,
          child: ProductListingScreen(
            category:
                argument?[ProductListingScreen.kCategory] as ShopCategory?,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.productDetailScreen,
      pageBuilder: (context, state) {
        final argument = state.extra as Map<String, dynamic>;
        return AppTransitions.buildPage(
          state: state,
          child: ProductDetailScreen(
            product: argument[ProductDetailScreen.kProduct] as Product,
          ),
        );
      },
    ),

    /// ---------------- Knowledge ----------------
    GoRoute(
      path: AppRoutePaths.knowledgebaseScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const KnowledgebaseScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.knowledgeSectionScreen,
      pageBuilder: (context, state) {
        final argument = state.extra as Map<String, dynamic>;
        return AppTransitions.buildPage(
          state: state,
          child: KnowledgeSectionScreen(
            section:
                argument[KnowledgeSectionScreen.kSection] as KnowledgeSection,
          ),
        );
      },
    ),

    /// ---------------- Community, testimonials, the show ----------------
    GoRoute(
      path: AppRoutePaths.communityScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const CommunityScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.testimonialsScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const TestimonialsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.saaltShowScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const SaaltShowScreen(),
      ),
    ),

    /// ---------------- TMI Parties ----------------
    GoRoute(
      path: AppRoutePaths.tmiPartiesScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const TmiPartiesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.webinarWizardScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const WebinarWizardScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.briefScreen,
      pageBuilder: (context, state) {
        final argument = state.extra as Map<String, dynamic>;
        return AppTransitions.buildPage(
          state: state,
          child: BriefScreen(
            draft: argument[BriefScreen.kDraft] as WebinarDraft,
          ),
        );
      },
    ),

    /// ---------------- Period tracker ----------------
    GoRoute(
      path: AppRoutePaths.periodTrackerScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const PeriodTrackerScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dayDetailScreen,
      pageBuilder: (context, state) {
        final argument = state.extra as Map<String, dynamic>;
        return AppTransitions.buildPage(
          state: state,
          child: DayDetailScreen(
            date: argument[DayDetailScreen.kDate] as DateTime,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.trackerSettingsScreen,
      pageBuilder: (context, state) => AppTransitions.buildPage(
        state: state,
        child: const TrackerSettingsScreen(),
      ),
    ),

    /// ---------------- Shared ----------------
    GoRoute(
      path: AppRoutePaths.videoPlayerScreen,
      pageBuilder: (context, state) {
        final argument = state.extra as Map<String, dynamic>;
        return AppTransitions.buildPage(
          state: state,
          child: VideoPlayerScreen(
            title: argument[VideoPlayerScreen.kTitle] as String,
            subtitle: argument[VideoPlayerScreen.kSubtitle] as String,
            url: argument[VideoPlayerScreen.kUrl] as String,
          ),
        );
      },
    ),
  ];

  static GoRouter createRouter({
    required bool hasToken,
    required bool isFirstTime,
  }) {
    return GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: mainNavigatorKey,
      redirect: _redirect,
      initialLocation: _initialRouteLocation(hasToken: hasToken),
      observers: [],
      routes: routes,
    );
  }

  static FutureOr<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) {
    return null;
  }
}
