import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';
import 'package:mind_metric/src/presentation/auth/login/login_page.dart';

/// Matches [LandingPage] gradient.
const Color _kLandingBgTop = Color(0xFF0D1230);
const Color _kLandingBgMid = Color(0xFF101438);
const Color _kLandingBgBottom = Color(0xFF151B4A);
const Color _kLandingMuted = Color(0xFFA9AEC1);

/// Shared "Time Expired" screen (quiz timer or creative submission timer).
class QuizTimeExpiredPage extends StatelessWidget {
  const QuizTimeExpiredPage({
    super.key,
    required this.onReturnToCompetitionHome,
  });

  static const route = '/quiz-time-expired';

  final VoidCallback onReturnToCompetitionHome;

  static const Color _logOutAccent = Color(0xFFFF7043);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _kLandingBgTop,
                _kLandingBgMid,
                _kLandingBgBottom,
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AccountThemeColors.gradientStart,
                            AccountThemeColors.accent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AccountThemeColors.accent.withValues(
                              alpha: 0.45,
                            ),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AccountThemeColors.gradientStart,
                        AccountThemeColors.accent,
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Time Expired',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You did not answer the question within the allowed time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your current attempt has ended.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2049),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Text(
                      'An email notification will be sent confirming this '
                      'incomplete attempt. You may purchase another entry '
                      '(max 10 per competition) to try again. Log out and log '
                      'back in to begin a new attempt.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _TimeExpiredPrimaryButton(
                    label: 'Return to Competition Home',
                    onTap: onReturnToCompetitionHome,
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginPage.route,
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _logOutAccent,
                      side: const BorderSide(color: _logOutAccent, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pure skill. One prize. One winner.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _kLandingMuted.withValues(alpha: 0.65),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeExpiredPrimaryButton extends StatelessWidget {
  const _TimeExpiredPrimaryButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AccountThemeColors.gradientStart,
            AccountThemeColors.accent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AccountThemeColors.accent.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
