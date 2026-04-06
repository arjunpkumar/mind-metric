import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/home/home_bloc.dart';
import 'package:mind_metric/src/application/bloc/home/home_event.dart';
import 'package:mind_metric/src/application/bloc/home/home_state.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';
import 'package:mind_metric/src/presentation/core/app_page.dart';
import 'package:mind_metric/src/presentation/core/base_state.dart';

const String _kLogoUrl =
    'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';

const Color _kHighlightGold = Color(0xFFFFE066);

/// Post-entry home: payment confirmation and entry into the qualification quiz.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = '/home';

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends BaseState<HomePage> {
  HomeBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc ??= context.read<HomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: AppPage(
            key: const Key('HomePage'),
            retryOnTap: () => _bloc?.add(HomeInit()),
            initStateStream: _bloc!.stream.map((s) => s.isInitCompleted),
            processStateStream: _bloc!.stream.map((s) => s.processState),
            isAppBarRequired: false,
            enableDrawerOpenDragGesture: false,
            backgroundColor: AccountThemeColors.background,
            child: const _PaymentSuccessHomeBody(),
          ),
        );
      },
    );
  }
}

class _PaymentSuccessHomeBody extends StatelessWidget {
  const _PaymentSuccessHomeBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: _kLogoUrl,
                height: 36,
                fit: BoxFit.contain,
                placeholder: (_, __) => const SizedBox(
                  height: 36,
                  width: 120,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AccountThemeColors.accent,
                      ),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Payment Successful',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your payment has been received and recorded.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AccountThemeColors.muted.withValues(alpha: 0.95),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'You may now begin the qualification quiz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kHighlightGold,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 28),
            _DarkInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'PAYMENT RECEIPT',
                    style: TextStyle(
                      color: AccountThemeColors.muted.withValues(alpha: 0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ReceiptRow(
                    label: 'Competition',
                    value: 'The Big Skill Challenge™',
                  ),
                  _ReceiptRow(
                    label: 'Prize',
                    value: 'BMW X5 SUV',
                  ),
                  _ReceiptRow(
                    label: 'Entry Fee Paid',
                    value: 'A\$2.99',
                  ),
                  _ReceiptRow(
                    label: 'Reference',
                    value: 'TBSC-2026-004521',
                  ),
                  _ReceiptRow(
                    label: 'Trust Account',
                    value: 'Confirmed',
                    trailing: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white.withValues(alpha: 0.95),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DarkInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AccountThemeColors.accent,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Important — Before You Begin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _ImportantBullet(
                    icon: Icons.timer_outlined,
                    iconColor: AccountThemeColors.muted,
                    child: Text(
                      'Each question is timed — answer within the time limit',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ImportantBullet(
                    icon: Icons.fact_check_outlined,
                    iconColor: AccountThemeColors.muted,
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(text: 'You must answer '),
                          TextSpan(
                            text: 'all questions correctly',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' — 100% pass required'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ImportantBullet(
                    icon: Icons.cancel_outlined,
                    iconColor: const Color(0xFFE53935),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(text: 'If timed out or incorrect, '),
                          TextSpan(
                            text: 'the attempt ends',
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ImportantBullet(
                    icon: Icons.refresh_rounded,
                    iconColor: AccountThemeColors.muted,
                    child: Text(
                      'You may purchase additional entries to try again '
                      '(max 10 total)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    AccountThemeColors.gradientStart,
                    AccountThemeColors.accent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AccountThemeColors.accent.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quiz flow coming soon.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Start Quiz →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pure skill. One prize. One winner.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AccountThemeColors.muted.withValues(alpha: 0.75),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkInfoCard extends StatelessWidget {
  const _DarkInfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AccountThemeColors.inputBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: child,
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(
              '$label:',
              style: TextStyle(
                color: AccountThemeColors.muted.withValues(alpha: 0.9),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 6),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _ImportantBullet extends StatelessWidget {
  const _ImportantBullet({
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}
