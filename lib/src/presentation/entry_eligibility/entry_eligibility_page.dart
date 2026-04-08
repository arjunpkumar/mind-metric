import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_event.dart';
import 'package:mind_metric/src/application/bloc/account/account_state.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';
import 'package:mind_metric/src/presentation/payment/payment_page.dart';

const String _kLogoUrl =
    'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';

/// Shown after email verification; Continue submits account and opens [HomePage].
class EntryEligibilityPage extends StatefulWidget {
  const EntryEligibilityPage({super.key});

  @override
  State<EntryEligibilityPage> createState() => _EntryEligibilityPageState();
}

class _EntryEligibilityPageState extends State<EntryEligibilityPage> {
  bool _eligible = false;
  bool _maxEntries = false;
  bool _skillAck = false;

  int get _checkedCount =>
      [_eligible, _maxEntries, _skillAck].where((v) => v).length;

  bool get _allChecked => _eligible && _maxEntries && _skillAck;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<AccountBloc, AccountState>(
        listenWhen: (p, c) =>
            p.accountCreationStatus != c.accountCreationStatus,
        listener: (context, state) {
          if (state.accountCreationStatus == AccountCreationStatus.success) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              PaymentPage.route,
              (route) => false,
            );
          } else if (state.accountCreationStatus ==
              AccountCreationStatus.failure) {
            final msg = state.accountCreationErrorMessage ??
                'Could not create account.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AccountThemeColors.inputBackground,
              ),
            );
          }
        },
        builder: (context, state) {
          final loading =
              state.accountCreationStatus == AccountCreationStatus.loading;
          return Scaffold(
            backgroundColor: AccountThemeColors.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: CachedNetworkImage(
                imageUrl: _kLogoUrl,
                height: 32,
                fit: BoxFit.contain,
                placeholder: (_, __) => const SizedBox(
                  height: 32,
                  width: 100,
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AccountThemeColors.accent,
                      ),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _EntryStepperRow(),
                  const SizedBox(height: 28),
                  const Text(
                    'Entry Eligibility',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please confirm the following before continuing.',
                    style: TextStyle(
                      color: AccountThemeColors.muted.withValues(alpha: 0.95),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _EligibilityCheckCard(
                    value: _eligible,
                    text:
                        'I confirm I am eligible to enter this competition.',
                    onChanged: (v) => setState(() => _eligible = v ?? false),
                  ),
                  const SizedBox(height: 12),
                  _EligibilityCheckCard(
                    value: _maxEntries,
                    text:
                        'I understand a maximum of 10 entries is permitted per competition.',
                    onChanged: (v) => setState(() => _maxEntries = v ?? false),
                  ),
                  const SizedBox(height: 12),
                  _EligibilityCheckCard(
                    value: _skillAck,
                    text:
                        'I acknowledge that this is a competition of skill, not chance.',
                    onChanged: (v) => setState(() => _skillAck = v ?? false),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1F45),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AccountThemeColors.accent.withValues(alpha: 0.85),
                      ),
                    ),
                    child: Text(
                      'Please confirm all $_checkedCount / 3 items above to continue.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Opacity(
                    opacity: (_allChecked && !loading) || loading ? 1 : 0.45,
                    child: DecoratedBox(
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
                            color: AccountThemeColors.accent.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _allChecked && !loading
                              ? () => context
                                  .read<AccountBloc>()
                                  .add(const SubmitAccountCreation())
                              : null,
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: loading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Continue →',
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
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2049),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AccountThemeColors.accent,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Important: Payment is processed into a designated '
                            'competition trust account. Entries are recorded '
                            'upon successful quiz completion and creative '
                            'submission.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EntryStepperRow extends StatelessWidget {
  const _EntryStepperRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StepDone(label: '1'),
        ),
        Expanded(
          child: _StepDone(label: '2'),
        ),
        Expanded(
          child: _StepActive(label: '3', subtitle: 'Eligibility'),
        ),
        Expanded(
          child: _StepPending(label: '4'),
        ),
      ],
    );
  }
}

class _StepDone extends StatelessWidget {
  const _StepDone({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF43A047),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _StepActive extends StatelessWidget {
  const _StepActive({required this.label, required this.subtitle});

  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AccountThemeColors.accent,
              width: 2,
            ),
            color: AccountThemeColors.accent.withValues(alpha: 0.2),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AccountThemeColors.accent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$label $subtitle',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AccountThemeColors.accent,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StepPending extends StatelessWidget {
  const _StepPending({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _EligibilityCheckCard extends StatelessWidget {
  const _EligibilityCheckCard({
    required this.value,
    required this.text,
    required this.onChanged,
  });

  final bool value;
  final String text;
  final ValueChanged<bool?> onChanged;

  static const double _toggleSize = 24;
  static const double _toggleRadius = 6;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: AccountThemeColors.inputBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: value
                  ? AccountThemeColors.accent
                  : Colors.white.withValues(alpha: 0.1),
              width: value ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EligibilityToggleBox(
                  selected: value,
                  size: _toggleSize,
                  borderRadius: _toggleRadius,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded square: orange fill + white check when selected; orange stroke only when not.
class _EligibilityToggleBox extends StatelessWidget {
  const _EligibilityToggleBox({
    required this.selected,
    required this.size,
    required this.borderRadius,
  });

  final bool selected;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? AccountThemeColors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AccountThemeColors.accent,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Center(
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              ),
            )
          : null,
    );
  }
}
