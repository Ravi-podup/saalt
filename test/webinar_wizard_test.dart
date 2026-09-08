import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/helper/session_store.dart';
import 'package:saalt/helper/tmi_helper.dart';
import 'package:saalt/models/webinar_draft.dart';
import 'package:saalt/presentation/parties/tmi_parties_screen.dart';
import 'package:saalt/presentation/parties/widgets/party_grid_card.dart';
import 'package:saalt/presentation/parties/wizard/webinar_wizard_screen.dart';
import 'package:saalt/presentation/parties/wizard/brief_screen.dart';
import 'package:saalt/presentation/parties/wizard/wizard_widgets.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Finder _body() => find
    .descendant(
      of: find.byKey(const Key('wizard-body')),
      matching: find.byType(Scrollable),
    )
    .first;

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(target, 240, scrollable: _body());
  await tester.pumpAndSettle();
}

Future<void> _toTop(WidgetTester tester) async {
  await tester.drag(_body(), const Offset(0, 4000));
  await tester.pumpAndSettle();
}

/// Reveals a target fully before tapping. scrollUntilVisible can stop with
/// the target flush against the viewport edge, where a tap does not land.
Future<void> _reveal(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> _open(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: WebinarWizardScreen()));
  await tester.pump(const Duration(milliseconds: 250));
}

Future<void> _continue(WidgetTester tester) async {
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

/// Fills the title and the schedule, which are the only required fields.
Future<void> _fillSetup(WidgetTester tester, String title) async {
  await tester.enterText(find.byType(TextField).first, title);
  await tester.pumpAndSettle();

  await _scrollTo(tester, find.text('Pick a date'));
  await tester.tap(find.text('Pick a date'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Pick a time'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(SessionStore.clear);
  tearDown(SessionStore.clear);

  group('the draft', () {
    test('needs a title and a schedule before it can finish', () {
      final draft = WebinarDraft();
      expect(draft.canFinish, isFalse);

      draft.title = 'Cup basics';
      expect(draft.canFinish, isFalse, reason: 'no schedule yet');

      draft.date = DateTime.now().add(const Duration(days: 1));
      draft.time = const TimeOfDay(hour: 18, minute: 0);
      expect(draft.canFinish, isTrue);
    });

    test('opening immediately counts as a schedule', () {
      final draft = WebinarDraft()
        ..title = 'Cup basics'
        ..startsImmediately = true;
      expect(draft.isScheduleReady, isTrue);
      expect(draft.canFinish, isTrue);
    });

    test('the brief fills only what it can, and never overwrites', () {
      final draft = WebinarDraft()
        ..about = 'A session for first-time cup users.'
        ..goal = 'Insert and remove a cup with confidence.';
      draft.applyBrief();

      expect(draft.description, 'A session for first-time cup users.');
      expect(
        draft.objectives.first,
        'Insert and remove a cup with confidence.',
      );
      // No title is invented: there is no model behind the button.
      expect(draft.title, isEmpty);

      // A description already written by hand wins.
      final written = WebinarDraft()
        ..description = 'Mine'
        ..about = 'Theirs';
      written.applyBrief();
      expect(written.description, 'Mine');
    });

    test('the brief summarises itself for the setup card', () {
      final draft = WebinarDraft();
      expect(draft.hasBrief, isFalse);
      expect(draft.briefTags, isEmpty);

      draft
        ..briefAudience = 'Teens'
        ..tone = 'Warm';
      expect(draft.hasBrief, isTrue);
      expect(draft.briefTags, ['Teens', 'Warm']);
    });

    test('a role brings its own permission defaults', () {
      expect(SpeakerRole.host.permissions['Start webinar'], isTrue);
      expect(SpeakerRole.presenter.permissions['Start webinar'], isFalse);
      expect(SpeakerRole.panelist.permissions['Video'], isFalse);
      expect(SpeakerRole.panelist.permissions['Audio'], isTrue);
    });
  });

  group('the flow', () {
    testWidgets('opens on step one of eight', (tester) async {
      _phone(tester);
      await _open(tester);

      expect(find.text('STEP 1 OF 8'), findsOneWidget);
      expect(find.text('Create your webinar'), findsOneWidget);
      expect(find.text('0% done'), findsNothing);
      expect(find.textContaining('% done'), findsOneWidget);
    });

    testWidgets('walks all eight steps and marks them off', (tester) async {
      _phone(tester);
      await _open(tester);

      for (var step = 1; step <= WizardStep.values.length; step++) {
        expect(
          find.text('STEP $step OF 8'),
          findsOneWidget,
          reason: 'should be on step $step',
        );
        expect(find.text(WizardStep.values[step - 1].title), findsOneWidget);
        if (step < WizardStep.values.length) {
          await _toTop(tester);
          await _continue(tester);
        }
      }

      // The last step offers Finish rather than Continue.
      expect(find.text('Finish'), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
      expect(find.text('100% done'), findsOneWidget);
    });

    testWidgets('the rail jumps straight to a step', (tester) async {
      _phone(tester);
      await _open(tester);

      final rail = find.byKey(const Key('wizard-rail'));
      await tester.dragUntilVisible(
        find.text('Thumbnail'),
        rail,
        const Offset(-120, 0),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thumbnail'));
      await tester.pumpAndSettle();

      expect(find.text('STEP 4 OF 8'), findsOneWidget);
      expect(find.text('Create your thumbnail'), findsOneWidget);
    });

    testWidgets('finishing without a title sends you back to setup', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);

      // Skip to the end without filling anything in.
      for (var i = 0; i < WizardStep.values.length - 1; i++) {
        await _toTop(tester);
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }
      await _toTop(tester);
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      expect(SessionStore.created.value, isEmpty);
      expect(find.text('STEP 1 OF 8'), findsOneWidget);
      // Said in place on the step that owns it, not in a message that goes.
      expect(
        find.text('Add a title and a schedule before finishing.'),
        findsOneWidget,
      );
    });
  });

  group('steps', () {
    testWidgets('the speakers step asks before showing a form', (tester) async {
      _phone(tester);
      await _open(tester);
      await _toTop(tester);
      await _continue(tester);

      expect(find.text('Do you want to add speakers?'), findsOneWidget);

      await tester.tap(find.text('Yes, add a speaker'));
      await tester.pumpAndSettle();
      expect(find.text('Add a speaker'), findsOneWidget);

      // The role card sits below the fold, so the list has to build it.
      await _scrollTo(tester, find.text('Speaker role'));
      expect(find.text('Speaker role'), findsOneWidget);
      await _toTop(tester);

      // A saved speaker becomes a row, and can be taken off again.
      await tester.enterText(find.byType(TextField).first, 'Asha');
      await _scrollTo(tester, find.text('Save speaker'));
      await _reveal(tester, find.text('Save speaker'));

      expect(find.text('Asha'), findsOneWidget);
      await tester.tap(find.byTooltip('Remove Asha'));
      await tester.pumpAndSettle();
      expect(find.text('Do you want to add speakers?'), findsOneWidget);
    });

    testWidgets('a panelist gets fewer permissions than a host', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);
      await _toTop(tester);
      await _continue(tester);
      await tester.tap(find.text('Yes, add a speaker'));
      await tester.pumpAndSettle();

      await _scrollTo(tester, find.text('Panelist'));
      // Host is the default, so screen sharing starts on.
      Switch permission(String label) => tester.widget<Switch>(
        find.descendant(
          of: find
              .ancestor(of: find.text(label), matching: find.byType(Row))
              .last,
          matching: find.byType(Switch),
        ),
      );
      expect(permission('Screen').value, isTrue);

      await tester.tap(find.text('Panelist'));
      await tester.pumpAndSettle();
      expect(permission('Screen').value, isFalse);
      expect(permission('Audio').value, isTrue);
    });

    testWidgets('the email step switches audience and counts what is on', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);
      for (var i = 0; i < 2; i++) {
        await _toTop(tester);
        await _continue(tester);
      }

      expect(find.text('STEP 3 OF 8'), findsOneWidget);
      expect(find.text('2 on'), findsOneWidget);
      expect(find.text('3 on'), findsOneWidget);
      expect(find.text('Invitation email'), findsOneWidget);

      await tester.tap(find.text('Attendees'));
      await tester.pumpAndSettle();
      expect(find.text('Registration confirmation'), findsOneWidget);
      expect(find.text('Invitation email'), findsNothing);
    });

    testWidgets('the review step reads the draft back', (tester) async {
      _phone(tester);
      await _open(tester);
      await _fillSetup(tester, 'Cup basics, live');
      await _toTop(tester);

      for (var i = 0; i < 4; i++) {
        await _toTop(tester);
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      expect(find.text('STEP 5 OF 8'), findsOneWidget);
      expect(find.text('Cup basics, live'), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('FREE'), findsOneWidget);
      await _scrollTo(tester, find.text('No speakers added yet.'));
      expect(find.text('No speakers added yet.'), findsOneWidget);
    });

    testWidgets('the brief opens on its own screen and fills the form', (
      tester,
    ) async {
      _phone(tester);
      await _open(tester);

      await tester.tap(find.text('Start with a brief'));
      await tester.pumpAndSettle();
      expect(find.byType(BriefScreen), findsOneWidget);

      // Nothing to carry over yet, so the action is disabled.
      expect(
        tester
            .widget<InkWell>(
              find
                  .ancestor(
                    of: find.text('Use this brief'),
                    matching: find.byType(InkWell),
                  )
                  .first,
            )
            .onTap,
        isNull,
      );

      await tester.enterText(
        find.byType(TextField).first,
        'Everything a first-time cup user needs.',
      );
      await tester.pumpAndSettle();

      final briefBody = find
          .descendant(
            of: find.byKey(const Key('brief-body')),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('Warm'),
        240,
        scrollable: briefBody,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Warm'));
      await tester.tap(find.text('Teens'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Use this brief'));
      await tester.pumpAndSettle();

      // Back on setup, with the description filled and the brief summarised.
      expect(find.byType(BriefScreen), findsNothing);
      expect(find.text('STEP 1 OF 8'), findsOneWidget);
      expect(find.text('Brief added'), findsOneWidget);
      expect(find.text('Teens'), findsOneWidget);
      expect(find.text('Warm'), findsOneWidget);
      await _scrollTo(
        tester,
        find.text('Everything a first-time cup user needs.'),
      );
      expect(
        find.text('Everything a first-time cup user needs.'),
        findsOneWidget,
      );
    });

    testWidgets('nothing on the flow pops a message', (tester) async {
      _phone(tester);
      await _open(tester);

      // Every design-only control is flat rather than tappable, so walking
      // the whole flow and prodding them raises no SnackBar.
      for (var step = 1; step <= WizardStep.values.length; step++) {
        for (final type in [SparkLink, UploadBox]) {
          // Re-counted each pass: a tap can rebuild the step and change how
          // many of these are on screen.
          for (var i = 0; ; i++) {
            if (i >= find.byType(type).evaluate().length) break;
            await tester.tap(find.byType(type).at(i), warnIfMissed: false);
            await tester.pump(const Duration(milliseconds: 50));
          }
        }
        expect(
          find.byType(SnackBar),
          findsNothing,
          reason: 'step \$step popped a message',
        );
        if (step < WizardStep.values.length) {
          await _toTop(tester);
          await tester.tap(find.text('Skip'));
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('every step lays out on a small phone', (tester) async {
      // 375x667, the narrowest phone worth supporting.
      tester.view.physicalSize = const Size(750, 1334);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await _open(tester);

      for (var step = 1; step <= WizardStep.values.length; step++) {
        for (var i = 0; i < 14; i++) {
          await tester.drag(_body(), const Offset(0, -320));
          await tester.pumpAndSettle();
        }
        if (step < WizardStep.values.length) {
          await _toTop(tester);
          await tester.tap(find.text('Skip'));
          await tester.pumpAndSettle();
        }
      }

      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('finishing puts the webinar on the schedule', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: TmiPartiesScreen()));
    await tester.pump(const Duration(milliseconds: 250));

    final before = find.byType(PartyGridCard).evaluate().length;

    await tester.tap(find.byTooltip('Schedule a webinar'));
    await tester.pumpAndSettle();
    expect(find.byType(WebinarWizardScreen), findsOneWidget);

    await _fillSetup(tester, 'Discs, live and unfiltered');

    // Straight to the end.
    for (var i = 0; i < WizardStep.values.length - 1; i++) {
      await _toTop(tester);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
    }
    await _toTop(tester);
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(find.byType(TmiPartiesScreen), findsOneWidget);
    expect(SessionStore.created.value, hasLength(1));
    expect(
      TmiHelper.upcoming.map((p) => p.title),
      contains('Discs, live and unfiltered'),
    );
    expect(find.byType(PartyGridCard).evaluate().length, before + 1);
  });
}
