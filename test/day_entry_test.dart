import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/helper/care_helper.dart';
import 'package:saalt/helper/entry_store.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/helper/tracker_settings.dart';
import 'package:saalt/models/day_entry.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/tracker/period_tracker_screen.dart';
import 'package:saalt/presentation/tracker/widgets/care_suggestions.dart';
import 'package:saalt/presentation/tracker/widgets/log_today_card.dart';

import 'helpers/router_host.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Finder _body(String key) => find
    .descendant(of: find.byKey(Key(key)), matching: find.byType(Scrollable))
    .first;

Future<void> _scrollTo(
  WidgetTester tester,
  Finder target, {
  String key = 'day-body',
}) async {
  await tester.scrollUntilVisible(target, 200, scrollable: _body(key));
  await tester.pumpAndSettle();
}

Future<void> _openDate(WidgetTester tester, DateTime date) async {
  final now = DateTime.now();
  final months = (date.year - now.year) * 12 + (date.month - now.month);
  for (var i = 0; i < months.abs(); i++) {
    await tester.tap(
      find.byTooltip(months > 0 ? 'Next month' : 'Previous month'),
    );
    await tester.pumpAndSettle();
  }
  final cell = find.descendant(
    of: find.byKey(const Key('calendar-grid')),
    matching: find.text('${date.day}'),
  );
  await _scrollTo(tester, cell, key: 'tracker-body');
  await tester.tap(cell);
  await tester.pumpAndSettle();
}

/// Back to the top of the day screen. scrollUntilVisible only travels one
/// way, so anything above the current position needs this first.
Future<void> _toTop(WidgetTester tester) async {
  await tester.drag(_body('day-body'), const Offset(0, 3000));
  await tester.pumpAndSettle();
}

DateTime _plainDay() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 12);
}

void main() {
  setUp(() {
    EntryStore.clear();
    TrackerSettings.reset();
  });
  tearDown(EntryStore.clear);

  group('entry store', () {
    test('a day reads back what was written to it', () {
      final date = DateTime(2026, 9, 12);
      EntryStore.save(
        date,
        const DayEntry(flow: 'Medium', symptoms: {'Cramps'}, mood: 'Low'),
      );

      final stored = EntryStore.forDate(date);
      expect(stored?.flow, 'Medium');
      expect(stored?.symptoms, {'Cramps'});
      expect(stored?.mood, 'Low');
      // Time of day must not matter: it is a date, not a moment.
      expect(EntryStore.hasEntry(DateTime(2026, 9, 12, 23, 59)), isTrue);
      expect(EntryStore.hasEntry(DateTime(2026, 9, 13)), isFalse);
    });

    test('saving an empty entry clears the day instead of storing a blank', () {
      final date = DateTime(2026, 9, 12);
      EntryStore.save(date, const DayEntry(flow: 'Light'));
      expect(EntryStore.count, 1);

      EntryStore.save(date, const DayEntry());
      expect(EntryStore.count, 0);
      expect(EntryStore.hasEntry(date), isFalse);
    });

    test('a stored entry does not alias the set it was built from', () {
      final date = DateTime(2026, 9, 12);
      final live = <String>{'Cramps'};
      EntryStore.save(date, DayEntry(flow: 'Light', symptoms: live));

      // The form keeps editing its own set after saving. That must not reach
      // back into what was stored.
      live.add('Fatigue');

      expect(EntryStore.forDate(date)?.symptoms, {'Cramps'});
    });

    test('a month reports only its own logged days', () {
      EntryStore.save(DateTime(2026, 9, 3), const DayEntry(flow: 'Light'));
      EntryStore.save(DateTime(2026, 9, 28), const DayEntry(mood: 'Calm'));
      EntryStore.save(DateTime(2026, 10, 4), const DayEntry(flow: 'Heavy'));

      expect(EntryStore.loggedDaysIn(DateTime(2026, 9)), {3, 28});
      expect(EntryStore.loggedDaysIn(DateTime(2026, 10)), {4});
      expect(EntryStore.loggedDaysIn(DateTime(2026, 8)), isEmpty);
    });
  });

  group('care suggestions', () {
    test('a logged flow decides the absorbency, not the calendar', () {
      final heavy = CareHelper.suggestions(flow: 'Heavy', isBleedingDay: true);
      expect(heavy, isNotEmpty);
      for (final product in heavy) {
        expect(
          ProductHelper.offers(product, 'Absorbency', {'Heavy', 'Super'}),
          isTrue,
          reason: '${product.name} was suggested for a heavy day',
        );
      }

      final light = CareHelper.suggestions(flow: 'Light', isBleedingDay: true);
      expect(light, isNotEmpty);
      for (final product in light) {
        expect(
          ProductHelper.offers(product, 'Absorbency', {'Light'}),
          isTrue,
          reason: '${product.name} was suggested for a light day',
        );
      }
    });

    test('nothing is suggested when there is nothing to suggest', () {
      // A day with no flow and no bleeding is not a shopping prompt.
      expect(CareHelper.suggestions(flow: null, isBleedingDay: false), isEmpty);
      // "None" is an answer, and the answer is no.
      expect(
        CareHelper.suggestions(flow: 'None', isBleedingDay: true),
        isEmpty,
      );
    });

    test('a bleeding day with no logged flow assumes an ordinary one', () {
      final suggestions = CareHelper.suggestions(
        flow: null,
        isBleedingDay: true,
      );
      expect(suggestions, isNotEmpty);
      for (final product in suggestions) {
        expect(
          ProductHelper.offers(product, 'Absorbency', {'Regular'}),
          isTrue,
        );
      }
    });

    test('the list stays short and never repeats a product', () {
      final suggestions = CareHelper.suggestions(
        flow: 'Heavy',
        isBleedingDay: true,
      );
      expect(suggestions.length, lessThanOrEqualTo(2));
      expect(
        suggestions.map((p) => p.name).toSet(),
        hasLength(suggestions.length),
      );
    });

    test('the reason says why, in the day\'s own terms', () {
      expect(
        CareHelper.reasonFor(flow: 'Heavy', isBleedingDay: true),
        'For a heavy day',
      );
      expect(
        CareHelper.reasonFor(flow: null, isBleedingDay: true),
        'For a period day',
      );
      expect(CareHelper.reasonFor(flow: null, isBleedingDay: false), '');
    });
  });

  group('logging a day', () {
    testWidgets('an entry comes back when the day is reopened', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));
      final date = _plainDay();
      await _openDate(tester, date);

      await _scrollTo(tester, find.text('Medium'));
      await tester.tap(find.text('Medium'));
      await tester.tap(find.text('Cramps'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save entry'));
      await tester.pumpAndSettle();

      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Update entry'), findsOneWidget);

      // Leave and come back.
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      await _openDate(tester, date);

      final stored = EntryStore.forDate(date);
      expect(stored?.flow, 'Medium');
      expect(stored?.symptoms, {'Cramps'});
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Update entry'), findsOneWidget);
    });

    testWidgets('edits made after saving are not stored until saved again', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));
      final date = _plainDay();
      await _openDate(tester, date);

      await _scrollTo(tester, find.text('Cramps'));
      await tester.tap(find.text('Cramps'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save entry'));
      await tester.pumpAndSettle();
      expect(EntryStore.forDate(date)?.symptoms, {'Cramps'});

      // Tick another symptom but walk away without saving.
      await tester.tap(find.text('Fatigue'));
      await tester.pumpAndSettle();
      expect(
        EntryStore.forDate(date)?.symptoms,
        {'Cramps'},
        reason: 'an unsaved tick must not reach the store',
      );

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      await _openDate(tester, date);

      expect(EntryStore.forDate(date)?.symptoms, {'Cramps'});
      final card = tester.widget<LogTodayCard>(find.byType(LogTodayCard));
      expect(card.symptoms, {'Cramps'});
    });

    testWidgets('the calendar marks the day and counts it', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));

      expect(find.text('Logged'), findsNothing);
      expect(find.textContaining('Tap any day to log it'), findsOneWidget);

      await _openDate(tester, _plainDay());
      await _scrollTo(tester, find.text('Light'));
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save entry'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // The key earns its place only now that something is logged.
      expect(find.text('Logged'), findsOneWidget);
      expect(find.textContaining('1 day logged this month'), findsOneWidget);
    });

    testWidgets('a stored day can be emptied, which clears it', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));
      final date = _plainDay();
      EntryStore.save(date, const DayEntry(flow: 'Heavy'));
      await _openDate(tester, date);

      await _scrollTo(tester, find.text('Heavy'));
      // Tapping the chosen flow again deselects it, leaving nothing.
      await tester.tap(find.text('Heavy'));
      await tester.pumpAndSettle();
      expect(find.text('Clear entry'), findsOneWidget);

      await tester.tap(find.text('Clear entry'));
      await tester.pumpAndSettle();

      expect(EntryStore.hasEntry(date), isFalse);
      expect(find.text('Save entry'), findsOneWidget);
    });
  });

  group('day screen', () {
    testWidgets('the arrows walk day by day without leaving the screen', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));
      final date = _plainDay();
      await _openDate(tester, date);

      await tester.tap(find.byTooltip('Next day'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Cycle day ${TrackerHelper.cycleDayFor(date.add(const Duration(days: 1)))}',
        ),
        findsWidgets,
      );

      await tester.tap(find.byTooltip('Previous day'));
      await tester.tap(find.byTooltip('Previous day'));
      await tester.pumpAndSettle();

      // Still one route deep: back returns to the calendar, not to a day.
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Period Tracker'), findsOneWidget);
    });

    testWidgets('each day carries its own entry as the arrows move', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));
      final date = _plainDay();
      EntryStore.save(date, const DayEntry(flow: 'Heavy'));
      await _openDate(tester, date);

      await _scrollTo(tester, find.byType(LogTodayCard));
      expect(find.text('Update entry'), findsOneWidget);

      await tester.tap(find.byTooltip('Next day'));
      await tester.pumpAndSettle();
      // The next day has nothing on it.
      expect(find.text('Save entry'), findsOneWidget);
      expect(find.text('Saved'), findsNothing);
    });

    testWidgets('suggestions follow the day, and open the product', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));

      // A plain mid-cycle day is not a shopping prompt.
      await _openDate(tester, _plainDay());
      expect(find.byType(CareSuggestions), findsNothing);

      // An expected period day is.
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      await _openDate(tester, TrackerHelper.nextPeriodStart);

      await _scrollTo(tester, find.byType(CareSuggestions));
      expect(find.text('For a period day'), findsOneWidget);

      // Logging a heavy flow changes both the reason and the products. The
      // chips sit above the card, and scrollUntilVisible only goes forwards,
      // so come back up first.
      await _toTop(tester);
      await tester.tap(find.text('Heavy'));
      await tester.pumpAndSettle();
      await _scrollTo(tester, find.byType(CareSuggestions));
      expect(find.text('For a heavy day'), findsOneWidget);

      final first = CareHelper.suggestions(
        flow: 'Heavy',
        isBleedingDay: true,
      ).first;
      await tester.tap(find.text(first.name));
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailScreen), findsOneWidget);
    });

    testWidgets('a future day is not described in the present tense', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));
      await _openDate(tester, TrackerHelper.nextPeriodStart);

      expect(find.text('Period expected'), findsOneWidget);
      expect(find.text('Predicted, not recorded'), findsOneWidget);
      // The blunt present-tense blurb belongs to recorded days only.
      expect(find.text('Bleeding'), findsNothing);
    });

    testWidgets('recorded cycles say how far they sat from the average', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));
      await _openDate(tester, _plainDay());

      await _scrollTo(tester, find.text('Recent cycles'));

      // Logged lengths are 28, 29, 27, 30, 28 against a mean of 28.
      expect(find.text('on avg'), findsNWidgets(2));
      expect(find.text('+1d'), findsOneWidget);
      expect(find.text('+2d'), findsOneWidget);
      expect(find.text('−1d'), findsOneWidget);
    });
  });
}
