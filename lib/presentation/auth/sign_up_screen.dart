import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/presentation/auth/widgets/auth_widgets.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.signupScreen);
  }

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Create an account',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                key: const Key('signup-body'),
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                children: [
                  const Text(
                    'Join Saalt',
                    style: TextStyle(
                      fontSize: 24,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Track your cycle, save what you like, and keep up with '
                    'the next TMI Party.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 26),
                  AuthField(
                    label: 'Your name',
                    hint: 'What should we call you?',
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    label: 'Email',
                    hint: 'you@example.com',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    label: 'Password',
                    hint: 'At least 8 characters',
                    controller: _password,
                    obscure: _obscure,
                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                  const SizedBox(height: 18),
                  _Terms(
                    value: _acceptedTerms,
                    onChanged: (value) =>
                        setState(() => _acceptedTerms = value),
                  ),
                  const SizedBox(height: 22),
                  AuthButton(label: 'Create account', onTap: () {}),
                  const SizedBox(height: 20),
                  const OrDivider(),
                  const SizedBox(height: 20),
                  GoogleButton(label: 'Sign up with Google', onTap: () {}),
                  const SizedBox(height: 24),
                  AuthSwitch(
                    question: 'Already have an account?',
                    action: 'Sign in',
                    onTap: () => context.pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Terms extends StatelessWidget {
  const _Terms({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          checked: value,
          child: Material(
            color: value ? AppColors.ink : AppColors.surface,
            borderRadius: BorderRadius.circular(7),
            child: InkWell(
              onTap: () => onChanged(!value),
              borderRadius: BorderRadius.circular(7),
              child: Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: value ? AppColors.ink : AppColors.hairline,
                    width: 1.4,
                  ),
                ),
                child: value
                    ? const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Text(
            'I agree to the terms of use and the privacy policy.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.inkMuted,
            ),
          ),
        ),
      ],
    );
  }
}
