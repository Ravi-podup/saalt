import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/testimonials/testimonials_screen.dart';
import 'package:saalt/presentation/testimonials/widgets/rating_summary.dart';
import 'package:saalt/presentation/testimonials/widgets/testimonial_card.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Future<void> _tapFilter(WidgetTester tester, String label) async {
  final chips = find.byKey(const Key('testimonial-filters'));
  final chip = find.descendant(of: chips, matching: find.text(label));
  // Trailing chips may be built but still off-screen, so scrolling into view
  // matters even when the finder resolves.
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
  testWidgets('summary reports the aggregate score and breakdown', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: TestimonialsScreen()));

    expect(find.byType(RatingSummary), findsOneWidget);
    // Eight reviews: five 5s, two 4s, one 3 -> 4.5 average.
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('8 reviews'), findsOneWidget);
    expect(find.byType(TestimonialCard), findsWidgets);
  });

  testWidgets('5 stars filter keeps only top-rated reviews', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: TestimonialsScreen()));

    await _tapFilter(tester, '5 stars');

    expect(find.text('5 reviews'), findsOneWidget);
    expect(find.text('Alina'), findsOneWidget);
    expect(find.text('Devi'), findsNothing); // 3 stars
  });

  testWidgets('Verified filter keeps only confirmed purchases', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: TestimonialsScreen()));

    await _tapFilter(tester, 'Verified');

    expect(find.text('5 reviews'), findsOneWidget);
    expect(find.byIcon(Icons.verified_rounded), findsWidgets);
    expect(find.text('Jess'), findsNothing); // unverified
  });

  testWidgets('the summary keeps describing the whole catalogue', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: TestimonialsScreen()));

    await _tapFilter(tester, '4 stars');

    // Average and total stay put; only the list narrows.
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('8 reviews'), findsOneWidget);
    expect(find.text('2 reviews'), findsOneWidget);
  });

  testWidgets('marking a review helpful bumps its count', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: TestimonialsScreen()));

    expect(find.text('128 found this helpful'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(TestimonialCard).first,
        matching: find.text('Helpful'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('129 found this helpful'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(TestimonialCard).first,
        matching: find.byIcon(Icons.thumb_up_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Testimonials tile on the dashboard opens the screen', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.tap(find.text('Testimonials'));
    await tester.pumpAndSettle();

    expect(find.byType(TestimonialsScreen), findsOneWidget);
  });

  testWidgets('every testimonial is a clip with a poster and a runtime', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: TestimonialsScreen()));

    expect(find.text('Real switch stories, on video'), findsOneWidget);

    final first = find.byType(TestimonialCard).first;
    // Poster carries the play badge and the runtime.
    expect(
      find.descendant(
        of: first,
        matching: find.byIcon(Icons.play_arrow_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: first, matching: find.text('4 min')),
      findsOneWidget,
    );
  });

  testWidgets('tapping the poster opens the player', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: TestimonialsScreen()));

    await tester.tap(
      find.descendant(
        of: find.byType(TestimonialCard).first,
        matching: find.byIcon(Icons.play_arrow_rounded),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(VideoPlayerScreen), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(VideoPlayerScreen),
        matching: find.textContaining('Alina'),
      ),
      findsOneWidget,
    );
  });
}
