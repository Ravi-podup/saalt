import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/models/cycle_log.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/tracker/period_tracker_screen.dart';
import 'package:saalt/presentation/tracker/widgets/cycle_calendar.dart';
import 'package:saalt/presentation/tracker/widgets/log_today_card.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Finder _body() => find
    .descendant(
      of: find.byKey(const Key('tracker-body')),
      matching: find.byType(Scrollable),
    )
    .first;

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(target, 200, scrollable: _body());
  await tester.pumpAndSettle();
}

void main() {
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

  testWidgets('opens on the status a user came for', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));

    expect(find.text('Period Tracker'), findsOneWidget);
    expect(find.text('DAY'), findsOneWidget);
    expect(find.text('${TrackerHelper.cycleDay}'), findsWidgets);
    expect(
      find.text(
        'Period in ${TrackerHelper.daysUntilNextPeriod} '
        '${TrackerHelper.daysUntilNextPeriod == 1 ? 'day' : 'days'}',
      ),
      findsOneWidget,
    );
  });

  testWidgets('calendar shows this month with a legend', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));

    await _scrollTo(tester, find.byType(CycleCalendar));
    expect(find.byType(CycleCalendar), findsOneWidget);
    for (final key in ['Period', 'Expected', 'Fertile']) {
      expect(find.text(key), findsWidgets, reason: '$key should be keyed');
    }
  });

  testWidgets('averages are reported as three stats', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));

    await _scrollTo(tester, find.text('Your averages'));
    expect(find.text('Cycle'), findsOneWidget);
    expect(find.text('Period'), findsWidgets);
    expect(find.text('Variation'), findsOneWidget);
    expect(find.text('±${TrackerHelper.variability}'), findsOneWidget);
  });

  testWidgets('logging is disabled until something is entered', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));

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
    await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));

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
    await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));

    await _scrollTo(tester, find.text('Recent cycles'));
    expect(
      find.textContaining('d period · '),
      findsNWidgets(TrackerHelper.history.length),
    );
  });

  testWidgets('predictions carry a plain-language caveat', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));

    await _scrollTo(tester, find.textContaining('not '));
    expect(
      find.textContaining('not contraception or medical advice'),
      findsOneWidget,
    );
  });

  testWidgets('the dashboard tracker card opens the screen', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.tap(find.text('Log today'));
    await tester.pumpAndSettle();

    expect(find.byType(PeriodTrackerScreen), findsOneWidget);
  });
}
