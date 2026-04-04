import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_bloc.dart';
import 'package:mind_metric/src/data/core/repository_provider.dart';
import 'package:mind_metric/src/presentation/auth/login/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(loginRepository: provideLoginRepository()),
      child: const LoginView(),
    );
  }
}
