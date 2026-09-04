import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/presentation/community/community_screen.dart';
import 'package:saalt/presentation/knowledgebase/knowledgebase_screen.dart';
import 'package:saalt/presentation/products/products_screen.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_images.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// The wordmark asset, wherever it appears.
Finder _wordmark() => find.byWidgetPredicate(
  (w) =>
      w is Image &&
      w.image is AssetImage &&
      (w.image as AssetImage).assetName == AppImages.logo,
);

Finder _inHeader(Finder inner) =>
    find.descendant(of: find.byType(ScreenHeader), matching: inner);

void main() {
  // The header names the screen; the wordmark lives in the bottom bar now.
  for (final entry in <String, Widget>{
    'Products': const ProductsScreen(),
    'Knowledgebase': const KnowledgebaseScreen(),
  }.entries) {
    testWidgets('${entry.key} header shows its title and a back button', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(MaterialApp(home: entry.value));

      expect(find.byType(ScreenHeader), findsOneWidget);
      expect(_inHeader(find.text(entry.key)), findsOneWidget);
      expect(_inHeader(find.byIcon(Icons.arrow_back_rounded)), findsOneWidget);
      // No wordmark in the header any more.
      expect(_inHeader(_wordmark()), findsNothing);
    });
  }

  testWidgets('the header title stays put while content scrolls', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: KnowledgebaseScreen()));

    final title = _inHeader(find.text('Knowledgebase'));
    final before = tester.getTopLeft(title);
    await tester.drag(
      find.byKey(const Key('kb-sections')),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(title), before);
  });

  testWidgets('Community header names itself without the wordmark', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    expect(find.text('Community'), findsOneWidget);
    // The only wordmark left on the screen is the bottom bar's Home tab.
    expect(
      find.descendant(of: find.byType(AppBottomNav), matching: _wordmark()),
      findsOneWidget,
    );
    expect(_wordmark(), findsOneWidget);
  });

  // Every bottom bar's Home tab shows the wordmark, not a house glyph.
  for (final entry in <String, Widget>{
    'Products': const ProductsScreen(),
    'Community': const CommunityScreen(),
  }.entries) {
    testWidgets('${entry.key} bottom bar Home carries the wordmark', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(MaterialApp(home: entry.value));

      final bar = find.byType(AppBottomNav);
      expect(bar, findsOneWidget);
      expect(
        find.descendant(of: bar, matching: find.text('Home')),
        findsOneWidget,
      );
      expect(find.descendant(of: bar, matching: _wordmark()), findsOneWidget);
      expect(
        find.descendant(of: bar, matching: find.byIcon(Icons.home_rounded)),
        findsNothing,
      );
    });
  }
}
