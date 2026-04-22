import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_event.dart';
import 'package:mind_metric/src/application/bloc/account/account_state.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';
import 'package:mind_metric/src/presentation/auth/verify_email/verify_email_page.dart';

/// Primary CTA; dispatches [SubmitAccountCreation]. Enabled from [AccountState.canSubmitCreateAccount].
class AccountCreateButton extends StatelessWidget {
  const AccountCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (p, c) =>
          p.canSubmitCreateAccount != c.canSubmitCreateAccount ||
          p.accountCreationStatus != c.accountCreationStatus,
      builder: (context, state) {
        final loading =
            state.accountCreationStatus == AccountCreationStatus.loading;
        final enabled = state.canSubmitCreateAccount && !loading;

        return Opacity(
          opacity: enabled || loading ? 1 : 0.5,
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
                  color: AccountThemeColors.accent.withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled
                    ? () {
                        context
                            .read<AccountBloc>()
                            .add(const SubmitAccountCreation());
                      }
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
                            'Create Account →',
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
        );
      },
    );
  }
}
