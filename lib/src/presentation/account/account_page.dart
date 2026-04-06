import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/data/core/repository_provider.dart';
import 'package:mind_metric/src/presentation/account/user_account_screen.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const route = '/account';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountBloc(accountRepository: provideAccountRepository()),
      child: const UserAccountScreen(),
    );
  }
}
