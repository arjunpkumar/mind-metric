import 'package:flutter/material.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';

class AccountFooterSection extends StatelessWidget {
  const AccountFooterSection({super.key, required this.onLogInTap});

  final VoidCallback onLogInTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onLogInTap,
          child: const Text(
            'Already have an account? Log in here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AccountThemeColors.accent,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: AccountThemeColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: Text(
            'Pure skill. One prize. One winner.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
