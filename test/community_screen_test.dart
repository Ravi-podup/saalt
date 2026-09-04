import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/presentation/community/community_screen.dart';
import 'package:saalt/presentation/community/widgets/post_card.dart';
import 'package:saalt/presentation/community/widgets/stories_row.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';
import 'package:saalt/presentation/dashboard_screen.dart';

/// Author name inside a post card. Names also appear in the stories strip,
/// so filter assertions must scope to the timeline.
Finder _author(String name) =>
    find.descendant(of: find.byType(PostCard), matching: find.text(name));

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('timeline shows posts, badges and the composer', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    expect(find.text('Community'), findsOneWidget);
    expect(find.text("What's on your mind today?"), findsOneWidget);
    expect(_author('Priya'), findsOneWidget);
    expect(find.text('MENTOR'), findsWidgets);
    expect(find.byType(PostCard), findsWidgets);
    expect(find.text('#CupLife'), findsOneWidget);
  });

  testWidgets('posts render their attached photo', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    // Post 2 carries a photo; post 1 does not.
    final withPhoto = find.descendant(
      of: find.ancestor(
        of: find.text('Kayla'),
        matching: find.byType(PostCard),
      ),
      matching: find.byType(Image),
    );
    expect(withPhoto, findsOneWidget);

    final withoutPhoto = find.descendant(
      of: find.ancestor(
        of: find.text('Priya'),
        matching: find.byType(PostCard),
      ),
      matching: find.byType(Image),
    );
    expect(withoutPhoto, findsNothing);
  });

  testWidgets('liking a post fills the heart and bumps the count', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    expect(find.text('24 found this helpful'), findsOneWidget);

    final firstPost = find.byType(PostCard).first;
    await tester.tap(
      find.descendant(of: firstPost, matching: find.text('Like')),
    );
    await tester.pumpAndSettle();

    expect(find.text('25 found this helpful'), findsOneWidget);
    expect(
      find.descendant(
        of: firstPost,
        matching: find.byIcon(Icons.favorite_rounded),
      ),
      findsWidgets,
    );
  });

  testWidgets('saving a post fills its bookmark', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    final firstPost = find.byType(PostCard).first;
    expect(
      find.descendant(
        of: firstPost,
        matching: find.byIcon(Icons.bookmark_border_rounded),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: firstPost, matching: find.text('Save')),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: firstPost,
        matching: find.byIcon(Icons.bookmark_rounded),
      ),
      findsOneWidget,
    );
  });

  Future<void> tapFilter(WidgetTester tester, String label) async {
    final chips = find.byKey(const Key('community-filters'));
    final chip = find.descendant(of: chips, matching: find.text(label));
    // Trailing chips start off-screen in the lazily-built horizontal list.
    if (chip.evaluate().isEmpty) {
      await tester.dragUntilVisible(chip, chips, const Offset(-120, 0));
      await tester.pumpAndSettle();
    }
    await tester.tap(chip);
    await tester.pumpAndSettle();
  }

  testWidgets('Text filter keeps only posts without an attachment', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    await tapFilter(tester, 'Text');

    expect(_author('Priya'), findsOneWidget); // no photo
    expect(_author('Kayla'), findsNothing); // has a photo
  });

  testWidgets('Photos filter excludes the clip', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    await tapFilter(tester, 'Photos');

    expect(_author('Kayla'), findsOneWidget);
    expect(_author('Priya'), findsNothing); // text only
    expect(_author('Sam'), findsNothing); // that one is a video
  });

  testWidgets('Videos filter shows the clip with a play overlay', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    await tapFilter(tester, 'Videos');

    expect(_author('Sam'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(_author('Kayla'), findsNothing);
  });

  testWidgets('Groups filter keeps only followed groups', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    await tapFilter(tester, 'Groups');

    expect(_author('Priya'), findsOneWidget); // Cup life
    expect(_author('Tomi'), findsOneWidget); // Postpartum
    expect(_author('Renee'), findsNothing); // Sustainability
  });

  testWidgets('stories strip leads with Add story', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    expect(find.byType(StoriesRow), findsOneWidget);
    expect(find.text('Add story'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(StoriesRow),
        matching: find.text('Kayla'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('bottom bar shows five tabs with a Chat badge', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: CommunityScreen()));

    final bar = find.byType(AppBottomNav);
    expect(bar, findsOneWidget);
    for (final label in ['Home', 'Groups', 'Chat', 'Events', 'You']) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
        reason: '$label tab should be present',
      );
    }
    expect(find.descendant(of: bar, matching: find.text('3')), findsOneWidget);
  });

  testWidgets('Community tile on the dashboard opens the timeline', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.tap(find.text('Community'));
    await tester.pumpAndSettle();

    expect(find.byType(CommunityScreen), findsOneWidget);
    expect(find.text('Community'), findsWidgets);
  });
}
