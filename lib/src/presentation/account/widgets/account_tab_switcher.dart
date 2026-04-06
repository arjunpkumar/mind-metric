import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_event.dart';
import 'package:mind_metric/src/application/bloc/account/account_state.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';

/// Side-by-side tabs: Create Account (active) vs Log In — driven by [AccountBloc].
class AccountTabSwitcher extends StatelessWidget {
  const AccountTabSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (p, c) => p.activeTab != c.activeTab,
      builder: (context, state) {
        final createActive = state.activeTab == AccountTab.createAccount;
        return Row(
          children: [
            Expanded(
              child: _TabSegment(
                label: 'Create Account',
                isActive: createActive,
                onTap: () => context
                    .read<AccountBloc>()
                    .add(const AccountTabChanged(AccountTab.createAccount)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TabSegment(
                label: 'Log In',
                isActive: !createActive,
                onTap: () => context
                    .read<AccountBloc>()
                    .add(const AccountTabChanged(AccountTab.logIn)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TabSegment extends StatelessWidget {
  const _TabSegment({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Material(
        color: AccountThemeColors.accent,
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        shadowColor: AccountThemeColors.accent.withValues(alpha: 0.45),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
