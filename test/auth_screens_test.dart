import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/presentation/auth/login_screen.dart';
import 'package:saalt/presentation/auth/sign_up_screen.dart';
import 'package:saalt/presentation/auth/widgets/auth_widgets.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/res/app_images.dart';

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
  required String key,
}) async {
  await tester.scrollUntilVisible(target, 220, scrollable: _body(key));
  await tester.pumpAndSettle();
}

void main() {
  group('login', () {
    testWidgets('shows the form, Google and the way to sign up', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const LoginScreen()));

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot your password?'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('or'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      // Google's own mark, not a letter in a box.
      final logo = tester.widget<Image>(
        find.descendant(
          of: find.byType(GoogleButton),
          matching: find.byType(Image),
        ),
      );
      expect((logo.image as AssetImage).assetName, AppImages.googleLogo);
      expect(find.text('G'), findsNothing);
      expect(find.text('Create an account'), findsOneWidget);
    });

    testWidgets('the password can be shown and hidden', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const LoginScreen()));

      bool isObscured() =>
          tester.widgetList<AuthField>(find.byType(AuthField)).last.obscure;

      expect(isObscured(), isTrue);
      await tester.tap(find.byTooltip('Show password'));
      await tester.pumpAndSettle();
      expect(isObscured(), isFalse);
      await tester.tap(find.byTooltip('Hide password'));
      await tester.pumpAndSettle();
      expect(isObscured(), isTrue);
    });

    testWidgets('the buttons are design only and go nowhere', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const LoginScreen()));

      await tester.enterText(find.byType(TextField).first, 'not-an-email');
      await tester.pumpAndSettle();

      for (final label in [
        'Sign in',
        'Continue with Google',
        'Forgot your password?',
      ]) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(
          find.byType(LoginScreen),
          findsOneWidget,
          reason: '$label should not navigate',
        );
      }

      // Nothing is validated and nothing pops up.
      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(DashboardScreen), findsNothing);
      expect(find.textContaining('does not look like'), findsNothing);
    });

    testWidgets('the sign-up link stays put when the form scrolls', (
      tester,
    ) async {
      // A short screen, so the body has to scroll under a pinned footer.
      tester.view.physicalSize = const Size(750, 1100);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(hosted(const LoginScreen()));

      final before = tester.getTopLeft(find.text('Create an account'));
      await tester.drag(_body('login-body'), const Offset(0, -260));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text('Create an account')),
        before,
        reason: 'the footer is pinned, not part of the scroll',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Create an account opens the sign-up screen and back again', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const LoginScreen()));

      await tester.tap(find.text('Create an account'));
      await tester.pumpAndSettle();
      expect(find.byType(SignUpScreen), findsOneWidget);

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });

  group('sign up', () {
    testWidgets('shows every field, the terms and Google', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const SignUpScreen()));

      expect(find.text('Join Saalt'), findsOneWidget);
      expect(find.text('Your name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(
        find.text('I agree to the terms of use and the privacy policy.'),
        findsOneWidget,
      );
      await _scrollTo(
        tester,
        find.text('Sign up with Google'),
        key: 'signup-body',
      );
      expect(find.text('Create account'), findsOneWidget);
      expect(find.text('Sign up with Google'), findsOneWidget);
    });

    testWidgets('the terms box ticks and unticks', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const SignUpScreen()));

      final box = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.checked != null,
      );
      bool isChecked() =>
          tester.widgetList<Semantics>(box).last.properties.checked!;

      expect(isChecked(), isFalse);
      await tester.tap(box.last);
      await tester.pumpAndSettle();
      expect(isChecked(), isTrue);
      await tester.tap(box.last);
      await tester.pumpAndSettle();
      expect(isChecked(), isFalse);
    });

    testWidgets('Create account is design only', (tester) async {
      _phone(tester);
      await tester.pumpWidget(hosted(const SignUpScreen()));

      await _scrollTo(tester, find.text('Create account'), key: 'signup-body');
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
      expect(find.byType(DashboardScreen), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });
  });

  testWidgets('the dashboard profile button opens sign in', (tester) async {
    _phone(tester);
    await tester.pumpWidget(hosted(const DashboardScreen()));

    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    // No in-app back button on the front door.
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);

    // System back still leaves, so nothing is trapped behind a dead button.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}
