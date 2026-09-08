import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/helper/dashboard_helper.dart';
import 'package:saalt/presentation/community/community_screen.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/knowledgebase/knowledgebase_screen.dart';
import 'package:saalt/presentation/parties/tmi_parties_screen.dart';
import 'package:saalt/presentation/products/products_screen.dart';
import 'package:saalt/presentation/show/saalt_show_screen.dart';
import 'package:saalt/presentation/testimonials/testimonials_screen.dart';

import 'helpers/router_host.dart';

void main() {
  testWidgets('dashboard shows all seven destinations', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(hosted(const DashboardScreen()));

    // The tracker hero is visible without scrolling.
    expect(find.text('Period Tracker'), findsOneWidget);
    expect(find.text('Ovulation window'), findsOneWidget);
    expect(find.text('Next period in 14 days'), findsOneWidget);

    const categories = [
      'Community',
      'Products',
      'Testimonials',
      'Knowledgebase',
      'TMI Parties',
      'Saalt Show',
    ];

    for (final title in categories) {
      final tile = find.text(title);
      await tester.scrollUntilVisible(
        tile,
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(tile, findsOneWidget, reason: '$title should be reachable');
    }
  });

  testWidgets('every tile opens its own screen', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // TMI Parties was the last placeholder; nothing on the grid dead-ends
    // in a snackbar any more.
    final destinations = <String, Type>{
      'Community': CommunityScreen,
      'Products': ProductsScreen,
      'Testimonials': TestimonialsScreen,
      'Knowledgebase': KnowledgebaseScreen,
      'TMI Parties': TmiPartiesScreen,
      'Saalt Show': SaaltShowScreen,
    };

    for (final entry in destinations.entries) {
      // A distinct key forces a fresh element tree. Re-pumping an identical
      // MaterialApp reuses the Navigator, which would keep the route pushed
      // by the previous pass.
      await tester.pumpWidget(
        hosted(const DashboardScreen(), key: ValueKey(entry.key)),
      );
      final tile = find.text(entry.key);
      await tester.scrollUntilVisible(
        tile,
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(tile);
      await tester.pumpAndSettle();

      expect(
        find.byType(entry.value),
        findsOneWidget,
        reason: '${entry.key} should open its own screen',
      );
    }
  });

  test('every dashboard tile has a cover photo', () {
    // Any decodable still: the covers are a mix of jpg and png, and Flutter
    // cannot decode avif, so that one is worth ruling out.
    final decodable = RegExp(r'\.(jpe?g|png|webp)$', caseSensitive: false);

    for (final item in DashboardHelper.items) {
      expect(
        item.imageAsset,
        startsWith('assets/images/'),
        reason: '${item.title} should show a photo, not just an icon',
      );
      expect(
        item.imageAsset,
        matches(decodable),
        reason: '${item.title} has a cover Flutter cannot decode',
      );
    }

    // No two tiles share a cover, or the grid reads as a mistake.
    final covers = DashboardHelper.items.map((i) => i.imageAsset).toList();
    expect(covers.toSet(), hasLength(covers.length));
  });
}
