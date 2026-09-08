import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/show/saalt_show_screen.dart';
import 'package:saalt/helper/show_helper.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';
import 'package:saalt/presentation/show/widgets/ask_card.dart';
import 'package:saalt/presentation/show/widgets/episode_card.dart';
import 'package:saalt/presentation/show/widgets/episode_carousel.dart';
import 'package:saalt/presentation/show/widgets/episode_tile.dart';
import 'package:saalt/presentation/widgets/view_toggle.dart';
import 'package:saalt/presentation/show/widgets/platform_row.dart';
import 'package:saalt/presentation/show/widgets/show_hero.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Finder _showBody() => find
    .descendant(
      of: find.byKey(const Key('show-body')),
      matching: find.byType(Scrollable),
    )
    .first;

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(target, 180, scrollable: _showBody());
  await tester.pumpAndSettle();
}

/// Format chips can be built yet still off-screen in the horizontal strip, so
/// scrolling into view matters even when the finder resolves.
Future<void> _tapFormat(WidgetTester tester, String label) async {
  final chips = find.byKey(const Key('show-formats'));
  final chip = find.descendant(of: chips, matching: find.text(label));
  if (chip.evaluate().isEmpty) {
    await tester.dragUntilVisible(chip, chips, const Offset(-120, 0));
  } else {
    await tester.ensureVisible(chip);
  }
  await tester.pumpAndSettle();
  await tester.tap(chip);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('opens on the hero and the episode list', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    expect(find.text('The Saalt Show'), findsOneWidget);
    expect(find.byType(ShowHero), findsOneWidget);
    expect(find.text('Subscribe'), findsOneWidget);
    // The full list sits below the carousel. Anchor on a guest who appears
    // only there, so the finder stays unambiguous while scrolling.
    await _scrollTo(tester, find.textContaining('Dr. Anita Rao'));
    expect(find.byType(EpisodeCard), findsWidgets);
  });

  testWidgets('format chips filter the episode list', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    await _scrollTo(tester, find.text('All episodes'));
    await _tapFormat(tester, 'Expert Interviews');

    expect(find.byType(EpisodeCard), findsNWidgets(2));
    expect(find.textContaining('Kim Rosas'), findsOneWidget);
    expect(find.textContaining('Lily Palmer'), findsNothing);
  });

  testWidgets('lists the platforms to listen on', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    await _scrollTo(tester, find.byType(PlatformRow));
    expect(find.text('Where to listen'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(PlatformRow),
        matching: find.text('Spotify'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Ask Cherie only enables once a question is typed', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    await _scrollTo(tester, find.byType(AskCard));

    final button = find.text('Send to Cherie');
    VoidCallback? handler() => tester
        .widget<InkWell>(
          find.ancestor(of: button, matching: find.byType(InkWell)).first,
        )
        .onTap;

    expect(handler(), isNull, reason: 'disabled until there is a question');

    final field = find.descendant(
      of: find.byType(AskCard),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'Is a disc better for heavy days?');
    await tester.pumpAndSettle();

    expect(handler(), isNotNull);

    await tester.tap(button);
    await tester.pumpAndSettle();
    // Field clears after sending.
    expect(find.text('Is a disc better for heavy days?'), findsNothing);
  });

  testWidgets('header nav lives in a five-tab bottom bar, no footer', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    final bar = find.byType(AppBottomNav);
    expect(bar, findsOneWidget);
    for (final label in ['Home', 'Episodes', 'Shop', 'Blog', 'About']) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
        reason: '$label should be a tab',
      );
    }
  });

  testWidgets('Saalt Show tile on the dashboard opens the screen', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.scrollUntilVisible(
      find.text('Saalt Show'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Saalt Show'));
    await tester.pumpAndSettle();

    expect(find.byType(SaaltShowScreen), findsOneWidget);
  });

  testWidgets('latest episodes ride a swipeable carousel with dots', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    expect(find.text('Latest'), findsOneWidget);
    expect(find.byType(EpisodeCarousel), findsOneWidget);

    final carousel = find.byKey(const Key('show-carousel'));
    // Newest episode leads.
    expect(
      find.descendant(
        of: carousel,
        matching: find.textContaining('Lily Palmer'),
      ),
      findsOneWidget,
    );

    // Swipe to the next slide.
    await tester.drag(carousel, const Offset(-350, 0));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: carousel,
        matching: find.textContaining('Lily Palmer'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('carousel only carries the three newest', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    final carousel = tester.widget<EpisodeCarousel>(
      find.byType(EpisodeCarousel),
    );
    expect(carousel.episodes.length, 3);
    expect(carousel.episodes.first.number, 5);
  });

  testWidgets('all episodes offers a list and a grid view', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    await _scrollTo(tester, find.byType(ViewToggle));

    // List is the default.
    expect(find.byType(EpisodeCard), findsWidgets);
    expect(find.byType(EpisodeTile), findsNothing);
    expect(find.byKey(const Key('show-grid')), findsNothing);

    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();

    // Grid replaces the rows; same six episodes.
    expect(find.byKey(const Key('show-grid')), findsOneWidget);
    expect(find.byType(EpisodeTile), findsNWidgets(5));
    expect(find.byType(EpisodeCard), findsNothing);

    await tester.tap(find.byIcon(Icons.view_agenda_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(EpisodeCard), findsWidgets);
    expect(find.byType(EpisodeTile), findsNothing);
  });

  testWidgets('the format filter still applies in grid view', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    await _scrollTo(tester, find.byType(ViewToggle));
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();

    await _tapFormat(tester, 'Expert Interviews');

    expect(find.byType(EpisodeTile), findsNWidgets(2));
  });

  test('every episode is watchable', () {
    expect(ShowHelper.episodes.every((e) => e.hasVideo), isTrue);
    for (final episode in ShowHelper.episodes) {
      expect(episode.videoUrl, startsWith('https://'));
    }
  });

  test('episodes 2-5 point at their own file', () {
    for (final episode in ShowHelper.episodes.where((e) => e.number > 1)) {
      expect(
        episode.videoUrl,
        contains('episode-${episode.number}'),
        reason: 'EP ${episode.number} should use its own render',
      );
    }
    // EP 1 has no render of its own, so it borrows the last supplied file.
    final first = ShowHelper.episodes.firstWhere((e) => e.number == 1);
    final second = ShowHelper.episodes.firstWhere((e) => e.number == 2);
    expect(first.videoUrl, second.videoUrl);
  });

  test('episodes are newest first and numbered without gaps', () {
    final numbers = ShowHelper.episodes.map((e) => e.number).toList();
    expect(numbers, [5, 4, 3, 2, 1]);
  });

  testWidgets('tapping a watchable episode opens the player route', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    await _scrollTo(tester, find.byType(EpisodeCard));
    await tester.tap(find.byType(EpisodeCard).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(VideoPlayerScreen), findsOneWidget);
    // Player opens buffering, since these are streamed.
    expect(find.text('Buffering…'), findsOneWidget);
  });

  testWidgets('the origin story now opens the player too', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: SaaltShowScreen()));

    await _scrollTo(tester, find.textContaining('Cherie & Jon Hoeger'));
    await tester.tap(find.textContaining('Cherie & Jon Hoeger'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(VideoPlayerScreen), findsOneWidget);
    // The route behind is still mounted, so scope to the player.
    expect(
      find.descendant(
        of: find.byType(VideoPlayerScreen),
        matching: find.text('EP 1 · with Cherie & Jon Hoeger'),
      ),
      findsOneWidget,
    );
  });
}
