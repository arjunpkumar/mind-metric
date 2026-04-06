import 'package:flutter/material.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';

class AccountLabeledField extends StatelessWidget {
  const AccountLabeledField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          style: const TextStyle(color: Colors.white),
          cursorColor: AccountThemeColors.accent,
          decoration: accountInputDecoration(hint: hint, errorText: errorText),
          onChanged: onChanged,
          onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
        ),
      ],
    );
  }
}
