import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/helper/session_store.dart';
import 'package:saalt/helper/tmi_helper.dart';
import 'package:saalt/presentation/parties/tmi_parties_screen.dart';
import 'package:saalt/presentation/parties/widgets/party_card.dart';
import 'package:saalt/presentation/parties/widgets/party_grid_card.dart';
import 'package:saalt/presentation/parties/widgets/party_hero.dart';
import 'package:saalt/presentation/widgets/view_toggle.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';

import 'helpers/router_host.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Finder _body() => find
    .descendant(
      of: find.byKey(const Key('parties-body')),
      matching: find.byType(Scrollable),
    )
    .first;

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(target, 200, scrollable: _body());
  await tester.pumpAndSettle();
}

/// Back to the top. scrollUntilVisible only travels forwards, so anything
/// above the current position needs this first.
Future<void> _toTop(WidgetTester tester) async {
  await tester.drag(_body(), const Offset(0, 2000));
  await tester.pumpAndSettle();
}

Future<void> _open(WidgetTester tester) async {
  await tester.pumpWidget(hosted(const TmiPartiesScreen()));
  await tester.pump(const Duration(milliseconds: 300));
}

/// A chip by label. Scoped to the filter row, since a label like "Upcoming"
/// is also a card's status.
Finder _chip(String label) => find.descendant(
  of: find.byKey(const Key('parties-filters')),
  matching: find.text(label),
);

/// Taps a filter chip, scrolling the chip row across first: the row is
/// clipped, so a chip off the right edge is not hittable until revealed.
Future<void> _tapChip(WidgetTester tester, String label) async {
  await tester.ensureVisible(_chip(label));
  await tester.pumpAndSettle();
  await tester.tap(_chip(label));
  await tester.pumpAndSettle();
}

/// Switches to the list, which is where the roomier cards live.
Future<void> _listView(WidgetTester tester) async {
  await tester.tap(
    find.descendant(
      of: find.byType(ViewToggle),
      matching: find.byIcon(Icons.view_agenda_outlined),
    ),
  );
  await tester.pumpAndSettle();
}

/// How many cards the current filter should render.
int _visible(WidgetTester tester) =>
    [...TmiHelper.live, ...TmiHelper.upcoming, ...TmiHelper.past].length;

void main() {
  setUp(() {
    TmiHelper.hideHowItWorks.value = false;
    SessionStore.clear();
  });
  tearDown(SessionStore.clear);

  group('schedule', () {
    test('every session lands in exactly one bucket', () {
      for (final party in TmiHelper.schedule) {
        final buckets = [
          party.isLive,
          party.isUpcoming,
          party.isOver,
        ].where((flag) => flag).length;
        expect(
          buckets,
          1,
          reason: '${party.title} is in $buckets buckets, not one',
        );
      }
    });

    test('the lists are sorted the way they are read', () {
      final upcoming = TmiHelper.upcoming;
      for (var i = 1; i < upcoming.length; i++) {
        expect(
          upcoming[i].startsInMinutes,
          greaterThanOrEqualTo(upcoming[i - 1].startsInMinutes),
          reason: 'coming up should run soonest first',
        );
      }

      final replays = TmiHelper.replays;
      for (var i = 1; i < replays.length; i++) {
        expect(
          replays[i].startsInMinutes,
          lessThanOrEqualTo(replays[i - 1].startsInMinutes),
          reason: 'replays should run most recent first',
        );
      }
    });

    test('only a live room is featured', () {
      expect(TmiHelper.live, isNotEmpty);
      expect(TmiHelper.featured, TmiHelper.live.first);
    });

    test('every finished session is in the past list, recorded or not', () {
      expect(TmiHelper.past.length, greaterThan(TmiHelper.replays.length));
      for (final party in TmiHelper.past) {
        expect(party.isOver, isTrue);
      }
    });

    test('only finished sessions offer a replay', () {
      for (final party in TmiHelper.schedule) {
        if (party.hasReplay) {
          expect(party.isOver, isTrue, reason: '${party.title} is not over');
        }
        if (!party.isOver) {
          expect(party.hasReplay, isFalse);
        }
      }
      // One session is deliberately unrecorded, so the empty case is real.
      expect(
        TmiHelper.schedule.where((p) => p.isOver && p.replayUrl == null),
        isNotEmpty,
      );
    });

    test('capacity maths never goes negative or over-full', () {
      for (final party in TmiHelper.schedule) {
        expect(party.booked, lessThanOrEqualTo(party.capacity));
        expect(party.spotsLeft, greaterThanOrEqualTo(0));
        expect(party.fillRatio, inInclusiveRange(0, 1));
      }
    });
  });

  group('date labels', () {
    test('countdowns pick the largest unit that reads naturally', () {
      expect(DateLabels.countdown(45), 'In 45 min');
      expect(DateLabels.countdown(60), 'In 1 hour');
      expect(DateLabels.countdown(180), 'In 3 hours');
      expect(DateLabels.countdown(60 * 24), 'In 1 day');
      expect(DateLabels.countdown(60 * 24 * 5), 'In 5 days');
      expect(DateLabels.countdown(0), 'Ended');
    });

    test('midnight and noon do not read as zero o\'clock', () {
      expect(DateLabels.time(DateTime(2026, 9, 8, 0, 5)), '12:05 am');
      expect(DateLabels.time(DateTime(2026, 9, 8, 12, 0)), '12:00 pm');
      expect(DateLabels.time(DateTime(2026, 9, 8, 18, 30)), '6:30 pm');
    });

    test('durations read as sessions, not minutes', () {
      expect(DateLabels.duration(45), '45 min');
      expect(DateLabels.duration(60), '1 hr');
      expect(DateLabels.duration(90), '1 hr 30 min');
    });
  });

  group('screen', () {
    testWidgets('opens on the live room', (tester) async {
      _phone(tester);
      await _open(tester);

      expect(find.text('TMI Parties'), findsOneWidget);
      expect(find.byType(PartyHero), findsOneWidget);
      // Flagged on the hero and again on the session's own card.
      expect(
        find.descendant(
          of: find.byType(PartyHero),
          matching: find.text('LIVE NOW'),
        ),
        findsOneWidget,
      );
      expect(find.text('LIVE NOW'), findsNWidgets(2));

      final featured = TmiHelper.featured!;
      // Twice: the hero shouts about it, and it is a card like any other.
      expect(find.text(featured.title), findsNWidgets(2));
      expect(
        find.descendant(
          of: find.byType(PartyHero),
          matching: find.text(featured.title),
        ),
        findsOneWidget,
      );
      // A live room is joined, not booked. Scoped to the hero, since the
      // cards below it are bookable sessions.
      expect(
        find.descendant(
          of: find.byType(PartyHero),
          matching: find.text('Join the room'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the filter chips narrow the console and count it', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);

      // Every filter is offered with its own count.
      for (final filter in PartyFilter.values) {
        expect(_chip(filter.label), findsOneWidget);
      }
      expect(find.byType(PartyGridCard), findsNWidgets(_visible(tester)));

      await _tapChip(tester, 'On-demand');
      expect(find.text(TmiHelper.upcoming.first.title), findsNothing);
      for (final replay in TmiHelper.replays) {
        expect(find.text(replay.title), findsOneWidget);
      }

      // Completed is a wider net than On-demand: it keeps the session that
      // was deliberately not recorded.
      await _tapChip(tester, 'Completed');
      expect(find.byType(PartyGridCard), findsNWidgets(TmiHelper.past.length));

      await _tapChip(tester, 'Live');
      // Scrolling the chip row can carry the hero off screen, so count the
      // cards rather than every mention of the title.
      expect(find.byType(PartyGridCard), findsNWidgets(TmiHelper.live.length));
      expect(find.text(TmiHelper.live.first.title), findsWidgets);
    });

    testWidgets('a card states what the session is and offers one action', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);

      final party = TmiHelper.upcoming.first;
      Finder inCard(Finder target) => find.descendant(
        of: find.ancestor(
          of: find.text(party.title),
          matching: find.byType(PartyGridCard),
        ),
        matching: target,
      );

      await _scrollTo(tester, find.text(party.title));

      expect(inCard(find.text('UPCOMING')), findsOneWidget);
      expect(inCard(find.text('Join')), findsOneWidget);
      // The registered count is the platform's, so tapping cannot change it.
      expect(inCard(find.text('${party.booked} registered')), findsOneWidget);

      await tester.tap(inCard(find.text('Join')));
      await tester.pumpAndSettle();

      expect(inCard(find.text('${party.booked} registered')), findsOneWidget);
      expect(inCard(find.text('Join')), findsOneWidget);
    });

    testWidgets('a completed session with no recording says so', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);

      final unrecorded = TmiHelper.past.firstWhere(
        (p) => p.replayUrl == null,
        orElse: () => throw StateError('nothing unrecorded to show'),
      );
      await _scrollTo(tester, find.text(unrecorded.title));

      Finder inCard(Finder target) => find.descendant(
        of: find.ancestor(
          of: find.text(unrecorded.title),
          matching: find.byType(PartyGridCard),
        ),
        matching: target,
      );

      // The footer carries a statement rather than a rule with nothing under
      // it, and offers no way to watch something that does not exist.
      expect(inCard(find.text('COMPLETED')), findsOneWidget);
      expect(inCard(find.text('Not recorded')), findsOneWidget);
      expect(inCard(find.text('Watch')), findsNothing);
      expect(inCard(find.text('Join')), findsNothing);
    });

    testWidgets('a completed session is never offered as joinable', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);
      await _listView(tester);

      final unrecorded = TmiHelper.past.firstWhere((p) => p.replayUrl == null);
      await _scrollTo(tester, find.text(unrecorded.title));

      expect(find.text('This one was not recorded'), findsOneWidget);
      expect(
        find.descendant(
          of: find.ancestor(
            of: find.text(unrecorded.title),
            matching: find.byType(PartyCard),
          ),
          matching: find.textContaining('Join'),
        ),
        findsNothing,
      );
    });

    testWidgets('every grid card is the same height', (tester) async {
      _phone(tester);
      await _open(tester);
      await _scrollTo(tester, find.byType(PartyGridCard).last);

      final heights = tester
          .widgetList<PartyGridCard>(find.byType(PartyGridCard))
          .map(
            (card) => tester
                .getSize(
                  find.ancestor(
                    of: find.text(card.party.title),
                    matching: find.byType(PartyGridCard),
                  ),
                )
                .height,
          )
          .toSet();

      expect(
        heights,
        hasLength(1),
        reason: 'cards of different heights leave the rows ragged',
      );

      // And the height is the card's own content, not a guessed ratio.
      final width = tester.getSize(find.byType(PartyGridCard).first).width;
      expect(heights.single, PartyGridCard.heightFor(width));
    });

    testWidgets('the view switch swaps grid cards for list cards', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);

      // The grid is the console default.
      expect(find.byType(PartyGridCard), findsWidgets);
      expect(find.byType(PartyCard), findsNothing);

      await _listView(tester);

      expect(find.byType(PartyCard), findsWidgets);
      expect(find.byType(PartyGridCard), findsNothing);
    });

    testWidgets('the menu lists the host actions, all of them live', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);

      final party = TmiHelper.upcoming.first;
      await _scrollTo(tester, find.text(party.title));

      final menu = find.descendant(
        of: find.ancestor(
          of: find.text(party.title),
          matching: find.byType(PartyGridCard),
        ),
        matching: find.byIcon(Icons.more_vert_rounded),
      );
      await tester.ensureVisible(menu);
      await tester.pumpAndSettle();
      await tester.tap(menu);
      await tester.pumpAndSettle();

      // Exactly the console's entries, and nothing greyed out.
      for (final entry in PartyMenu.entries) {
        expect(
          find.text(entry.label),
          findsOneWidget,
          reason: '${entry.label} is missing',
        );
        expect(
          tester
              .widget<PopupMenuItem<int>>(
                find.ancestor(
                  of: find.text(entry.label),
                  matching: find.byType(PopupMenuItem<int>),
                ),
              )
              .enabled,
          isTrue,
          reason: '${entry.label} should not be disabled',
        );
      }
      expect(find.byType(PopupMenuItem<int>), findsNWidgets(6));

      // Design only: choosing one changes nothing and goes nowhere.
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(TmiPartiesScreen), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('Delete this session?'), findsNothing);
      expect(find.text(party.title), findsWidgets);
    });

    testWidgets('tapping a card opens its description', (tester) async {
      _phone(tester);
      await _open(tester);

      final party = TmiHelper.upcoming.first;
      await _scrollTo(tester, find.text(party.title));
      await tester.tap(find.text(party.title));
      await tester.pumpAndSettle();

      // The sheet carries what a grid card has no room for.
      expect(find.text(party.blurb), findsOneWidget);
      expect(
        find.textContaining('registered of ${party.capacity}'),
        findsOneWidget,
      );
      for (final topic in party.topics) {
        expect(find.text(topic), findsOneWidget);
      }
    });

    testWidgets('a list card carries the count and the one action', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);
      await _listView(tester);

      final party = TmiHelper.upcoming.first;
      await _scrollTo(tester, find.text(party.title));

      Finder inCard(Finder target) => find.descendant(
        of: find.ancestor(
          of: find.text(party.title),
          matching: find.byType(PartyCard),
        ),
        matching: target,
      );

      expect(inCard(find.text('${party.booked} going')), findsOneWidget);
      expect(inCard(find.text('Join this session')), findsOneWidget);

      // Tapping cannot move a count the app does not own.
      await tester.tap(inCard(find.text('Join this session')));
      await tester.pumpAndSettle();
      expect(inCard(find.text('${party.booked} going')), findsOneWidget);
    });

    testWidgets('a sold-out session offers no way in', (tester) async {
      _phone(tester);
      await _open(tester);
      await _listView(tester);

      final full = TmiHelper.upcoming.firstWhere(
        (p) => p.isFull,
        orElse: () => throw StateError('no sold-out session to render'),
      );
      await _scrollTo(tester, find.text(full.title));

      expect(find.text('No places left'), findsNWidgets(2));

      final button = find.ancestor(
        of: find.text('No places left').last,
        matching: find.byType(InkWell),
      );
      expect(tester.widget<InkWell>(button.first).onTap, isNull);
    });

    testWidgets('a nearly full session says how few are left', (tester) async {
      _phone(tester);
      await _open(tester);
      await _listView(tester);

      final tight = TmiHelper.upcoming.firstWhere(
        (p) => p.isNearlyFull,
        orElse: () => throw StateError('no nearly full session to show'),
      );
      await _scrollTo(tester, find.text(tight.title));
      expect(find.text('Only ${tight.spotsLeft} left'), findsOneWidget);
    });

    testWidgets('a replay opens the player', (tester) async {
      _phone(tester);
      await _open(tester);
      await _listView(tester);

      await _tapChip(tester, 'On-demand');

      final replay = TmiHelper.replays.first;
      await _scrollTo(tester, find.text(replay.title));
      await tester.tap(find.text('Watch the replay').first);
      // Not pumpAndSettle: the player sits on a buffering spinner, which
      // never settles.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(VideoPlayerScreen), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(VideoPlayerScreen),
          matching: find.text(replay.title),
        ),
        findsOneWidget,
      );
    });

    testWidgets('every card lays out on a small phone', (tester) async {
      // 375x667 logical, the narrowest phone worth supporting. A RenderFlex
      // overflow fails the test, so this stands in for eyeballing it.
      tester.view.physicalSize = const Size(750, 1334);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await _open(tester);

      for (final isGrid in [true, false]) {
        await _toTop(tester);
        if (!isGrid) await _listView(tester);

        for (final filter in PartyFilter.values) {
          await _toTop(tester);
          await _tapChip(tester, filter.label);

          // Walk the whole list so every card gets laid out.
          for (var i = 0; i < 12; i++) {
            await tester.drag(_body(), const Offset(0, -320));
            await tester.pumpAndSettle();
          }
        }
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('the explainer is one line at the top, not a block at the '
        'bottom', (tester) async {
      _phone(tester);
      await _open(tester);

      final banner = find.textContaining('First time?');
      expect(banner, findsOneWidget);
      // The steps are behind it, not laid out down the page.
      expect(
        find.textContaining(TmiHelper.howItWorks.first.title),
        findsNothing,
      );

      await tester.tap(banner);
      await tester.pumpAndSettle();

      expect(find.text('How a TMI Party works'), findsOneWidget);
      for (final step in TmiHelper.howItWorks) {
        expect(find.textContaining(step.title), findsOneWidget);
      }

      // Reading it puts it away.
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
      expect(banner, findsNothing);
      expect(TmiHelper.hideHowItWorks.value, isTrue);
    });

    testWidgets('the banner can be dismissed without reading it', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);

      await tester.tap(find.byTooltip('Hide this'));
      await tester.pumpAndSettle();
      expect(find.textContaining('First time?'), findsNothing);
    });

    testWidgets('the caveat stays at the foot of the page', (tester) async {
      _phone(tester);
      await _open(tester);

      await _scrollTo(tester, find.textContaining('not medical advice'));
      expect(find.textContaining('not medical advice'), findsOneWidget);
      // The footnote must not still advertise bookings the app cannot make.
      expect(find.textContaining('Bookings'), findsNothing);
    });
  });
}
