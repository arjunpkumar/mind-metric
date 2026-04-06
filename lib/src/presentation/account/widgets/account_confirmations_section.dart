import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_event.dart';
import 'package:mind_metric/src/application/bloc/account/account_state.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';

/// Age + terms checkboxes; dispatches [AccountAgeConfirmationChanged] /
/// [AccountTermsConfirmationChanged]. Terms line uses gold underlined link spans.
class AccountConfirmationsSection extends StatelessWidget {
  const AccountConfirmationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (p, c) =>
          p.ageConfirmed != c.ageConfirmed || p.termsConfirmed != c.termsConfirmed,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: state.ageConfirmed,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (v) => context.read<AccountBloc>().add(
                            AccountAgeConfirmationChanged(v ?? false),
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'I confirm I am 18 years or older',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: state.termsConfirmed,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (v) => context.read<AccountBloc>().add(
                            AccountTermsConfirmationChanged(v ?? false),
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TermsAgreementRichLine(
                    onTermsTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Terms and Conditions'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    onRulesTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Competition Rules'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TermsAgreementRichLine extends StatelessWidget {
  const _TermsAgreementRichLine({
    required this.onTermsTap,
    required this.onRulesTap,
  });

  final VoidCallback onTermsTap;
  final VoidCallback onRulesTap;

  static const _linkStyle = TextStyle(
    color: AccountThemeColors.accent,
    fontSize: 14,
    height: 1.35,
    decoration: TextDecoration.underline,
    decorationColor: AccountThemeColors.accent,
  );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4,
      children: [
        const Text(
          'I agree to the ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.35,
          ),
        ),
        GestureDetector(
          onTap: onTermsTap,
          child: const Text('Terms and Conditions', style: _linkStyle),
        ),
        const Text(
          ' and ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.35,
          ),
        ),
        GestureDetector(
          onTap: onRulesTap,
          child: const Text('Competition Rules', style: _linkStyle),
        ),
      ],
    );
  }
}
