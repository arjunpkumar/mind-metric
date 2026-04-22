import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_event.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_state.dart';
import 'package:mind_metric/src/presentation/account/account_page.dart';
import 'package:mind_metric/src/presentation/entry_eligibility/entry_eligibility_page.dart';

const Color _kBg = Color(0xFF101438);
const Color _kMuted = Color(0xFFA9AEC1);
const Color _kInputBg = Color(0xFF1A2049);
const Color _kAccent = Color(0xFFFF9E0F);
const Color _kGradientStart = Color(0xFFFFBB5C);
const String _kLogoUrl =
    'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _kBg,
        body: BlocConsumer<LoginBloc, LoginState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == LoginFormStatus.submissionSuccess) {
              final name = state.email.trim();
              Navigator.of(context).pushNamedAndRemoveUntil(
                EntryEligibilityPage.route,
                (route) => false,
                arguments: EntryEligibilityRouteArgs.postLogin(
                  userName: name.isEmpty ? null : name,
                ),
              );
            } else if (state.status == LoginFormStatus.submissionFailure) {
              final msg =
                  state.submissionErrorMessage ?? 'Invalid credentials';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _kInputBg,
                ),
              );
            }
          },
          builder: (context, state) {
            final submitting =
                state.status == LoginFormStatus.submissionInProgress;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: _kLogoUrl,
                        width: 150,
                        height: 40,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const SizedBox(
                          width: 150,
                          height: 40,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _kAccent,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => const Icon(
                          Icons.image_not_supported_outlined,
                          color: _kMuted,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Log in to continue your journey.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _kMuted,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _SegmentedTabs(
                      onCreateAccountTap: () {
                        Navigator.of(context).pushNamed(AccountPage.route);
                      },
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0x33FFFFFF), height: 1),
                    const SizedBox(height: 24),
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: state.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: _kAccent,
                      decoration: _fieldDecoration(
                        hint: 'your@email.com',
                        errorText: state.emailError,
                      ),
                      onChanged: (v) => context
                          .read<LoginBloc>()
                          .add(LoginEmailChanged(v)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: state.password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: _kAccent,
                      decoration: _fieldDecoration(
                        hint: 'Enter your password',
                        errorText: state.passwordError,
                      ),
                      onChanged: (v) => context
                          .read<LoginBloc>()
                          .add(LoginPasswordChanged(v)),
                      onFieldSubmitted: (_) {
                        if (!submitting) {
                          context.read<LoginBloc>().add(const LoginSubmitted());
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password reset coming soon.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot your password? Reset here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _kAccent,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: _kAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _LoginGradientButton(
                      enabled: !submitting,
                      onPressed: () => context
                          .read<LoginBloc>()
                          .add(const LoginSubmitted()),
                      child: submitting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Log In →',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AccountPage.route);
                        },
                        child: const Text(
                          "Don't have an account? Sign up here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _kAccent,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: _kAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pure skill. One prize. One winner.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static InputDecoration _fieldDecoration({
    required String hint,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _kMuted),
      errorText: errorText,
      filled: true,
      fillColor: _kInputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _kAccent, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.onCreateAccountTap});

  final VoidCallback onCreateAccountTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCreateAccountTap,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _kAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _kAccent.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Log In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginGradientButton extends StatelessWidget {
  const _LoginGradientButton({
    required this.onPressed,
    required this.child,
    required this.enabled,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [_kGradientStart, _kAccent],
          ),
          boxShadow: [
            BoxShadow(
              color: _kAccent.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
