import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/presentation/auth/sign_up_screen.dart';
import 'package:saalt/presentation/auth/widgets/auth_widgets.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.loginScreen);
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _createAccount() {
    SignUpScreen.open(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                key: const Key('login-body'),
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                children: [
                  const AuthHeader(
                    title: 'Welcome back',
                    detail:
                        'Sign in to pick up your cycle, your bag and the '
                        'sessions you follow.',
                  ),
                  const SizedBox(height: 28),
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
                    autofillHints: const [AutofillHints.password],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        // Inert like the rest of this screen, but it looks
                        // like a link, so it has to feel like one.
                        onTap: () {},
                        borderRadius: BorderRadius.circular(30),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AuthButton(
                    label: 'Sign in',
                    onTap: () {
                      DashboardScreen.open(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  const OrDivider(),
                  const SizedBox(height: 20),
                  GoogleButton(label: 'Continue with Google', onTap: () {}),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: AuthSwitch(
                question: 'New to Saalt?',
                action: 'Create an account',
                onTap: _createAccount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
