import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/helper/entry_store.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/helper/tracker_settings.dart';
import 'package:saalt/models/cycle_log.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/tracker/day_detail_screen.dart';
import 'package:saalt/presentation/tracker/period_tracker_screen.dart';
import 'package:saalt/presentation/tracker/widgets/cycle_calendar.dart';
import 'package:saalt/presentation/tracker/widgets/cycle_chart.dart';
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

/// Opens the tracker and taps into [date], walking the month arrows first if
/// it is not in the month the calendar opens on. Tapping a day is the only
/// route to the entry form and the statistics now.
Future<void> _openDate(WidgetTester tester, DateTime date) async {
  await tester.pumpWidget(hosted(const PeriodTrackerScreen()));

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

/// How the day screen titles a date, so the test does not hardcode a weekday
/// that stops being true next month.
String _headerLabel(DateTime date) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${weekdays[date.weekday - 1]}, ${date.day} '
      '${months[date.month - 1]}';
}

/// A day in the month the calendar opens on, for tests that only need some
/// day rather than a particular one.
DateTime _someDay() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 12);
}

void main() {
  // The stores are global, so a test that touches them must not leak into
  // the next one.
  setUp(() {
    TrackerSettings.reset();
    EntryStore.clear();
  });

  group('cycle maths', () {
    test('averages and variability come from the logged history', () {
      // Lengths 28, 29, 27, 30, 28 -> mean 28.4, spread 3.
      expect(TrackerHelper.averageCycle, 28);
      expect(TrackerHelper.averagePeriod, 5);
      expect(TrackerHelper.variability, 3);
    });

    test('day 1 is the first day of bleeding', () {
      expect(TrackerHelper.cycleDay, TrackerHelper.current.startedDaysAgo + 1);
    });

    test('phases follow the cycle in order', () {
      expect(TrackerHelper.phaseFor(1), CyclePhase.menstrual);
      expect(TrackerHelper.phaseFor(5), CyclePhase.menstrual);
      expect(TrackerHelper.phaseFor(8), CyclePhase.follicular);
      expect(TrackerHelper.phaseFor(15), CyclePhase.ovulation);
      expect(TrackerHelper.phaseFor(25), CyclePhase.luteal);
    });

    test('the headline phase never contradicts the calendar shading', () {
      for (var day = 1; day <= TrackerHelper.averageCycle; day++) {
        if (TrackerHelper.isFertile(day) && day > TrackerHelper.averagePeriod) {
          expect(
            TrackerHelper.phaseFor(day),
            CyclePhase.ovulation,
            reason: 'day $day is shaded fertile, so it must read as ovulation',
          );
        }
      }
    });

    test('the next period is one average cycle after the last start', () {
      expect(
        TrackerHelper.nextPeriodStart
            .difference(TrackerHelper.current.startDate)
            .inDays,
        TrackerHelper.averageCycle,
      );
      expect(TrackerHelper.daysUntilNextPeriod, greaterThan(0));
    });
  });

  group('dates', () {
    test('a cycle is numbered from its own first bleeding day', () {
      final start = TrackerHelper.current.startDate;
      expect(TrackerHelper.cycleDayFor(start), 1);
      expect(TrackerHelper.cycleDayFor(start.add(const Duration(days: 6))), 7);
      expect(TrackerHelper.cycleDayFor(DateTime.now()), TrackerHelper.cycleDay);
    });

    test('day numbering wraps instead of running past the cycle', () {
      // The next expected period is day 1 of the cycle after this one.
      expect(TrackerHelper.cycleDayFor(TrackerHelper.nextPeriodStart), 1);
      expect(
        TrackerHelper.cycleDayFor(
          TrackerHelper.nextPeriodStart.add(const Duration(days: 3)),
        ),
        4,
      );
    });

    test('older cycles keep their own numbering, not the current one', () {
      final older = TrackerHelper.history[2];
      expect(TrackerHelper.cycleDayFor(older.startDate), 1);
      expect(
        TrackerHelper.cycleDayFor(older.startDate.add(const Duration(days: 2))),
        3,
      );
    });

    test('recorded bleeding days are numbered within the bleed', () {
      final start = TrackerHelper.current.startDate;
      expect(TrackerHelper.isPeriodDate(start), isTrue);
      expect(TrackerHelper.periodDayFor(start), 1);
      expect(
        TrackerHelper.periodDayFor(
          start.add(Duration(days: TrackerHelper.current.periodLength - 1)),
        ),
        TrackerHelper.current.periodLength,
      );
      // The day after the bleed ends is no longer a period day.
      expect(
        TrackerHelper.periodDayFor(
          start.add(Duration(days: TrackerHelper.current.periodLength)),
        ),
        isNull,
      );
    });

    test('predictions start at the next expected period', () {
      expect(
        TrackerHelper.isPredictedDate(TrackerHelper.nextPeriodStart),
        isTrue,
      );
      expect(
        TrackerHelper.isPredictedDate(
          TrackerHelper.nextPeriodStart.subtract(const Duration(days: 1)),
        ),
        isFalse,
      );
    });

    test('future months are not blank: the prediction keeps projecting', () {
      final now = DateTime.now();
      for (var ahead = 1; ahead <= 4; ahead++) {
        final month = DateTime(now.year, now.month + ahead);
        expect(
          TrackerHelper.predictedDaysIn(month),
          isNotEmpty,
          reason: 'month +$ahead should show an expected period',
        );
      }
    });

    test('a day is never shaded both bleeding and fertile', () {
      final now = DateTime.now();
      for (var ahead = -3; ahead <= 3; ahead++) {
        final month = DateTime(now.year, now.month + ahead);
        final period = TrackerHelper.periodDaysIn(month);
        expect(
          TrackerHelper.fertileDaysIn(month).intersection(period),
          isEmpty,
          reason: 'month $ahead double-shades a day',
        );
        expect(
          TrackerHelper.predictedDaysIn(month).intersection(period),
          isEmpty,
          reason: 'month $ahead marks a recorded day as expected',
        );
      }
    });

    test('the status counts down, then counts the delay', () {
      expect(
        TrackerHelper.statusLabel,
        'Period in ${TrackerHelper.daysUntilNextPeriod} days',
      );
    });
  });

  group('calendar screen', () {
    testWidgets('opens on the calendar and nothing else', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));

      expect(find.text('Period Tracker'), findsOneWidget);
      expect(find.byType(CycleCalendar), findsOneWidget);
      expect(
        find.text(CycleCalendar.monthLabel(DateTime.now()).toUpperCase()),
        findsOneWidget,
      );
      for (final key in ['Period', 'Expected', 'Fertile']) {
        expect(find.text(key), findsWidgets, reason: '$key should be keyed');
      }
      // The entry form and the statistics live one tap deeper now.
      expect(find.byType(LogTodayCard), findsNothing);
      expect(find.byType(CycleChart), findsNothing);
    });

    testWidgets('the strip says where the cycle is', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));

      expect(
        find.text(
          'Cycle day ${TrackerHelper.cycleDay} · ${TrackerHelper.phase.label}',
        ),
        findsOneWidget,
      );
      expect(find.text(TrackerHelper.statusLabel), findsOneWidget);
    });

    testWidgets('the arrows walk through the months', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));

      final now = DateTime.now();
      final next = DateTime(now.year, now.month + 1);
      final previous = DateTime(now.year, now.month - 1);

      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(
        find.text(CycleCalendar.monthLabel(next).toUpperCase()),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('Previous month'));
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();
      expect(
        find.text(CycleCalendar.monthLabel(previous).toUpperCase()),
        findsOneWidget,
      );
    });

    testWidgets('a way back to today appears only once you have left', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));

      expect(find.byIcon(Icons.today_rounded), findsNothing);

      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.today_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.today_rounded));
      await tester.pumpAndSettle();
      expect(
        find.text(CycleCalendar.monthLabel(DateTime.now()).toUpperCase()),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.today_rounded), findsNothing);
    });

    testWidgets('tapping a day opens that day', (tester) async {
      _phone(tester);
      final date = _someDay();
      await _openDate(tester, date);

      expect(find.byType(DayDetailScreen), findsOneWidget);
      // The header names the date; the ring carries the cycle day.
      expect(find.text(_headerLabel(date)), findsOneWidget);
      expect(find.text('DAY'), findsOneWidget);
      expect(find.text('${TrackerHelper.cycleDayFor(date)}'), findsWidgets);
    });

    testWidgets('the strip opens today', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const PeriodTrackerScreen()));

      await tester.tap(find.text(TrackerHelper.statusLabel));
      await tester.pumpAndSettle();

      expect(find.byType(DayDetailScreen), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Log today'), findsOneWidget);
    });
  });

  group('day screen', () {
    testWidgets('a day opens at the top, whatever the last day was', (
      tester,
    ) async {
      _phone(tester);
      await _openDate(tester, _someDay());

      // Scroll one day deep into the statistics.
      await _scrollTo(tester, find.text('Recent cycles'));
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // A different day must not inherit that offset.
      final other = _someDay().add(const Duration(days: 1));
      final cell = find.descendant(
        of: find.byKey(const Key('calendar-grid')),
        matching: find.text('${other.day}'),
      );
      await tester.tap(cell);
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Scrollable>(_body('day-body'))
            .controller!
            .position
            .pixels,
        0,
        reason: 'the day should open at the top',
      );
    });

    testWidgets('a recorded bleeding day says which day of the bleed it is', (
      tester,
    ) async {
      _phone(tester);
      // The last bleed may have started in the previous month, so let the
      // helper walk back to it.
      await _openDate(tester, TrackerHelper.current.startDate);

      expect(find.text('Period day 1'), findsOneWidget);
    });

    testWidgets('the day carries the graph and the averages', (tester) async {
      _phone(tester);
      await _openDate(tester, _someDay());

      await _scrollTo(tester, find.byType(CycleChart));
      expect(
        find.text('Last ${TrackerHelper.history.length} cycles'),
        findsOneWidget,
      );

      // One bar per recorded cycle.
      for (var i = 0; i < TrackerHelper.history.length; i++) {
        expect(find.byKey(Key('cycle-bar-$i')), findsOneWidget);
      }

      await _scrollTo(tester, find.text('Variation'));
      expect(find.text('Avg cycle'), findsOneWidget);
      expect(find.text('Avg period'), findsOneWidget);
      expect(find.text('±${TrackerHelper.variability}'), findsOneWidget);
    });

    testWidgets('bar heights track the cycle lengths', (tester) async {
      _phone(tester);
      await _openDate(tester, _someDay());
      await _scrollTo(tester, find.byType(CycleChart));

      // Drawn oldest first, so reverse the newest-first history.
      final ordered = TrackerHelper.history.reversed.toList();
      final heights = [
        for (var i = 0; i < ordered.length; i++)
          tester.getSize(find.byKey(Key('cycle-bar-$i'))).height,
      ];

      for (var i = 0; i < ordered.length; i++) {
        for (var j = 0; j < ordered.length; j++) {
          if (ordered[i].cycleLength <= ordered[j].cycleLength) continue;
          expect(
            heights[i],
            greaterThan(heights[j]),
            reason:
                'a ${ordered[i].cycleLength} day cycle must draw taller than '
                'a ${ordered[j].cycleLength} day one',
          );
        }
      }
    });

    testWidgets('logging is disabled until something is entered', (
      tester,
    ) async {
      _phone(tester);
      await _openDate(tester, _someDay());

      await _scrollTo(tester, find.byType(LogTodayCard));

      final save = find.text('Save entry');
      VoidCallback? handler() => tester
          .widget<InkWell>(
            find.ancestor(of: save, matching: find.byType(InkWell)).first,
          )
          .onTap;
      expect(handler(), isNull);

      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();
      expect(handler(), isNotNull);

      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('symptoms multi-select, flow and mood are single choice', (
      tester,
    ) async {
      _phone(tester);
      await _openDate(tester, _someDay());

      await _scrollTo(tester, find.byType(LogTodayCard));

      await tester.tap(find.text('Cramps'));
      await tester.tap(find.text('Fatigue'));
      await tester.pumpAndSettle();

      // Both stay chosen.
      final card = tester.widget<LogTodayCard>(find.byType(LogTodayCard));
      expect(card.symptoms, containsAll(['Cramps', 'Fatigue']));

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Heavy'));
      await tester.pumpAndSettle();

      // Flow replaces rather than accumulates.
      expect(
        tester.widget<LogTodayCard>(find.byType(LogTodayCard)).flow,
        'Heavy',
      );
    });

    testWidgets('recent cycles list every logged cycle', (tester) async {
      _phone(tester);
      await _openDate(tester, _someDay());

      await _scrollTo(tester, find.text('Recent cycles'));
      expect(
        find.textContaining('d period · '),
        findsNWidgets(TrackerHelper.history.length),
      );
    });

    testWidgets('predictions carry a plain-language caveat', (tester) async {
      _phone(tester);
      await _openDate(tester, _someDay());

      await _scrollTo(tester, find.textContaining('not contraception'));
      expect(
        find.textContaining('not contraception or medical advice'),
        findsOneWidget,
      );
    });
  });

  testWidgets('the dashboard tracker card opens the calendar', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const DashboardScreen()));

    await tester.tap(find.text('Log today'));
    await tester.pumpAndSettle();

    expect(find.byType(PeriodTrackerScreen), findsOneWidget);
    expect(find.byType(CycleCalendar), findsOneWidget);
  });
}
