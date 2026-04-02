import 'package:flutter/material.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_state.dart';
import 'package:mind_metric/src/presentation/core/app_page.dart';
import 'package:mind_metric/src/presentation/core/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : login_page
/// Project : FlutterBase

class LoginPage extends StatefulWidget {
  static const route = "/login";

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends BaseState<LoginPage> {
  LoginBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_bloc == null) {
      _bloc = BlocProvider.of<LoginBloc>(context);
      _bloc!.message.listen((v) => showMessage(v));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AppPage(
          key: const Key("LoginPage"),
          retryOnTap: () {},
          initStateStream: _bloc!.stream.map((s) => s.isInitCompleted),
          processStateStream: _bloc!.stream.map((s) => s.processState),
          title: S.current.titleLogin,
          child: _getBodyLayout(context, state),
        );
      },
    );
  }

  Widget _getBodyLayout(
    BuildContext context,
    LoginState state,
  ) {
    return Container();
  }
}
