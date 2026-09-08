import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/helper/knowledge_helper.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/knowledgebase/knowledge_section_screen.dart';
import 'package:saalt/presentation/knowledgebase/knowledgebase_screen.dart';
import 'package:saalt/presentation/knowledgebase/widgets/article_row.dart';
import 'package:saalt/presentation/knowledgebase/widgets/section_panel.dart';

import 'helpers/router_host.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Finder _sectionsList() => find
    .descendant(
      of: find.byKey(const Key('kb-sections')),
      matching: find.byType(Scrollable),
    )
    .first;

/// Opens a section from the chooser, scrolling to it if it is below the fold.
Future<void> _choose(WidgetTester tester, String title) async {
  final card = find.widgetWithText(SectionPanel, title);
  if (card.evaluate().isEmpty) {
    await tester.scrollUntilVisible(card, 200, scrollable: _sectionsList());
  } else {
    await tester.ensureVisible(card);
  }
  await tester.pumpAndSettle();
  await tester.tap(card);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('landing screen asks you to choose an area', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    expect(find.text('Knowledgebase'), findsOneWidget);
    expect(find.text('Search all guides and videos…'), findsOneWidget);

    // Every dashboard area is offered, and no articles are shown yet.
    for (final title in [
      'Community',
      'Products',
      'Testimonials',
      'TMI Parties',
      'Saalt Show',
    ]) {
      expect(
        find.widgetWithText(SectionPanel, title),
        findsOneWidget,
        reason: '$title should be a choice',
      );
    }
    expect(find.byType(ArticleRow), findsNothing);
  });

  testWidgets('each panel reports how much knowledge it holds', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    expect(
      find.descendant(
        of: find.widgetWithText(SectionPanel, 'Products'),
        matching: find.text('8 guides'),
      ),
      findsOneWidget,
    );
    // Testimonials counts videos, not guides.
    expect(
      find.descendant(
        of: find.widgetWithText(SectionPanel, 'Testimonials'),
        matching: find.text('4 videos'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Testimonials is the video section', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    final card = find.widgetWithText(SectionPanel, 'Testimonials');
    expect(
      find.descendant(of: card, matching: find.text('VIDEO')),
      findsOneWidget,
    );
    // Only that one carries the flag.
    expect(find.text('VIDEO'), findsOneWidget);
  });

  testWidgets('choosing Products shows only Products knowledge', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    await _choose(tester, 'Products');

    expect(find.byType(KnowledgeSectionScreen), findsOneWidget);
    expect(find.byType(ArticleRow), findsWidgets);
    expect(find.textContaining('8 guides'), findsOneWidget);
    expect(find.text('Finding your size on the first try'), findsOneWidget);
    // Nothing from another section leaks in.
    expect(find.text('What mentors actually do'), findsNothing);
  });

  testWidgets('choosing Testimonials shows videos, timed as watch', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    await _choose(tester, 'Testimonials');

    expect(find.textContaining('4 videos'), findsOneWidget);
    expect(find.text('6 min watch'), findsOneWidget);
    expect(find.textContaining('min read'), findsNothing);
    expect(find.byType(ArticleRow), findsNWidgets(4));
  });

  testWidgets('every section holds at least one item', (tester) async {
    for (final section in KnowledgeHelper.sections) {
      expect(
        KnowledgeHelper.itemsFor(section.title),
        isNotEmpty,
        reason: '${section.title} should not be an empty section',
      );
    }
  });

  testWidgets('search narrows within the chosen section only', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    await _choose(tester, 'Products');
    await tester.enterText(find.byType(TextField), 'softener');
    await tester.pumpAndSettle();

    expect(find.text('Washing period underwear the right way'), findsOneWidget);
    expect(find.byType(ArticleRow), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzzzz');
    await tester.pumpAndSettle();
    expect(find.text('No guides match "zzzzz"'), findsOneWidget);
  });

  testWidgets('quick answers stay on the landing screen', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    final question = find.text('Can it get lost inside me?');
    await tester.scrollUntilVisible(question, 250, scrollable: _sectionsList());
    await tester.pumpAndSettle();

    expect(find.textContaining('closed space that ends'), findsNothing);
    await tester.tap(question);
    await tester.pumpAndSettle();
    expect(find.textContaining('closed space that ends'), findsOneWidget);
  });

  testWidgets('Knowledgebase tile on the dashboard opens the chooser', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const DashboardScreen()));

    await tester.tap(find.text('Knowledgebase'));
    await tester.pumpAndSettle();

    expect(find.byType(KnowledgebaseScreen), findsOneWidget);
    expect(find.byType(SectionPanel), findsWidgets);
  });

  testWidgets('each panel previews what is inside it', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    expect(find.byType(SectionPanel), findsWidgets);

    // Community's panel names its own first guides, so no two panels look
    // alike and you can see what a section holds before opening it.
    final community = find.widgetWithText(SectionPanel, 'Community');
    expect(
      find.descendant(
        of: community,
        matching: find.text('Finding the right group for your stage'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: community, matching: find.text('4 guides')),
      findsOneWidget,
    );
    // Four items, two previewed.
    expect(
      find.descendant(of: community, matching: find.text('2 more')),
      findsOneWidget,
    );
  });

  testWidgets('search spans the whole library, not one section', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    await tester.enterText(find.byType(TextField), 'period');
    await tester.pumpAndSettle();

    // Panels give way to flat results drawn from several sections.
    expect(find.byType(SectionPanel), findsNothing);
    expect(find.textContaining('across the library'), findsOneWidget);
    expect(find.byType(ArticleRow), findsWidgets);

    await tester.enterText(find.byType(TextField), 'zzzzz');
    await tester.pumpAndSettle();
    expect(find.text('Nothing matches "zzzzz"'), findsOneWidget);
  });

  testWidgets('the landing screen is not a grid of tiles', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const KnowledgebaseScreen()));

    expect(find.byType(GridView), findsNothing);
  });
}
