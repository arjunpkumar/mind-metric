import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_event.dart';
import 'package:mind_metric/src/application/bloc/account/account_state.dart';
import 'package:mind_metric/src/presentation/account/widgets/account_labeled_field.dart';
import 'package:mind_metric/src/presentation/auth/verify_email/verify_email_page.dart';

/// Owns [TextEditingController]s; syncs when bloc clears email/password; dispatches change events.
class AccountSyncedTextFields extends StatefulWidget {
  const AccountSyncedTextFields({super.key});

  @override
  State<AccountSyncedTextFields> createState() =>
      _AccountSyncedTextFieldsState();
}

class _AccountSyncedTextFieldsState extends State<AccountSyncedTextFields> {
  static final RegExp _emailRegex = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final FocusNode _passwordFocus;

  @override
  void initState() {
    super.initState();
    final s = context.read<AccountBloc>().state;
    _email = TextEditingController(text: s.email);
    _password = TextEditingController(text: s.password);
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _onEmailFieldSubmitted(BuildContext context) async {
    final trimmed = _email.text.trim();
    context.read<AccountBloc>().add(AccountEmailChanged(trimmed));
    if (!_emailRegex.hasMatch(trimmed)) {
      return;
    }
    final verified = await Navigator.of(context).pushNamed(
      VerifyEmailPage.route,
      arguments: trimmed,
    );
    if (!context.mounted) {
      return;
    }
    if (verified == true) {
      _passwordFocus.requestFocus();
    }
  }

  void _syncFromStateIfNeeded(AccountState state) {
    if (_email.text != state.email) {
      _email.value = TextEditingValue(
        text: state.email,
        selection: TextSelection.collapsed(offset: state.email.length),
      );
    }
    if (_password.text != state.password) {
      _password.value = TextEditingValue(
        text: state.password,
        selection: TextSelection.collapsed(offset: state.password.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listenWhen: (p, c) => p.email != c.email || p.password != c.password,
      listener: (context, state) => _syncFromStateIfNeeded(state),
      child: BlocBuilder<AccountBloc, AccountState>(
        buildWhen: (p, c) =>
            p.emailError != c.emailError || p.passwordError != c.passwordError,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccountLabeledField(
                label: 'Email Address',
                hint: 'your@email.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                errorText: state.emailError,
                onChanged: (v) =>
                    context.read<AccountBloc>().add(AccountEmailChanged(v)),
                onSubmitted: () => _onEmailFieldSubmitted(context),
              ),
              const SizedBox(height: 20),
              AccountLabeledField(
                label: 'Password',
                hint: 'Create a password (min 8 characters)',
                controller: _password,
                focusNode: _passwordFocus,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                textInputAction: TextInputAction.done,
                errorText: state.passwordError,
                onChanged: (v) =>
                    context.read<AccountBloc>().add(AccountPasswordChanged(v)),
                onSubmitted: () => context
                    .read<AccountBloc>()
                    .add(const SubmitAccountCreation()),
              ),
            ],
          );
        },
      ),
    );
  }
}
