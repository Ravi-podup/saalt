import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/presentation/dashboard_screen.dart';

void main() {
  testWidgets('dashboard shows all seven destinations', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

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

  testWidgets('a tile without a screen yet acknowledges the tap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    // Community, Products, Knowledgebase, Testimonials and Saalt Show all
    // navigate now; TMI Parties is the last placeholder. It sits in the third
    // grid row, so scroll it into view first.
    final tile = find.text('TMI Parties');
    await tester.scrollUntilVisible(
      tile,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('TMI Parties coming up'), findsOneWidget);
  });
}
