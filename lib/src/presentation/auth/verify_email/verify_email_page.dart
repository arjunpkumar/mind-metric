import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/verify_email/verify_email_bloc.dart';
import 'package:mind_metric/src/data/core/repository_provider.dart';
import 'package:mind_metric/src/presentation/auth/verify_email/verify_email_view.dart';

/// Route: [route] with `settings.arguments` as [VerifyEmailRouteArgs] or [String] email.
class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({
    super.key,
    required this.email,
    this.accountBloc,
  });

  static const route = '/verify-email';

  final String email;
  final AccountBloc? accountBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyEmailBloc(
        repository: provideVerifyEmailRepository(),
        email: email.trim(),
      ),
      child: VerifyEmailView(
        maskedEmail: maskEmailForDisplay(email.trim()),
        accountBloc: accountBloc,
      ),
    );
  }
}

/// Pass from create-account flow so OTP success can open [EntryEligibilityPage] with the same bloc.
class VerifyEmailRouteArgs {
  const VerifyEmailRouteArgs({
    required this.email,
    this.accountBloc,
  });

  final String email;
  final AccountBloc? accountBloc;
}

String maskEmailForDisplay(String email) {
  final at = email.indexOf('@');
  if (at <= 0 || at == email.length - 1) {
    return email;
  }
  final local = email.substring(0, at);
  final domain = email.substring(at + 1);
  if (local.isEmpty) {
    return email;
  }
  return '${local[0]}***@$domain';
}
