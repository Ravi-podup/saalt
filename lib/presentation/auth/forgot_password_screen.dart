import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/presentation/auth/widgets/auth_widgets.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// Asking for a reset link. Static like the rest of the auth screens: the
/// field takes what you type and the button is live to the touch, but
/// nothing is sent and the screen does not move on.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.forgotPasswordScreen);
  }

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

// Stateful only to own the controller's lifecycle; nothing here calls
// setState.
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                key: const Key('forgot-body'),
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                children: [
                  const AuthHeader(
                    title: 'Forgot your password?',
                    detail:
                        'Enter the email on your account and we will send '
                        'you a link to set a new one.',
                  ),
                  const SizedBox(height: 28),
                  AuthField(
                    label: 'Email',
                    hint: 'you@example.com',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: 22),
                  AuthButton(label: 'Send reset link', onTap: () {}),
                  const SizedBox(height: 18),
                  const _Note(
                    icon: Icons.lock_outline_rounded,
                    text:
                        'The link lets you set a new password once. Your '
                        'current one keeps working until you do.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: AuthSwitch(
                question: 'Remembered it?',
                action: 'Back to sign in',
                onTap: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A quiet reassurance under the form.
class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.inkFaint),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: AppColors.inkFaint,
            ),
          ),
        ),
      ],
    );
  }
}
