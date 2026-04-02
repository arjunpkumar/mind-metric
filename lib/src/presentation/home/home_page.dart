import 'package:flutter/material.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/application/bloc/home/home_bloc.dart';
import 'package:mind_metric/src/application/bloc/home/home_state.dart';
import 'package:mind_metric/src/presentation/core/app_page.dart';
import 'package:mind_metric/src/presentation/core/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : home_page
/// Project : FlutterBase

class HomePage extends StatefulWidget {
  static const route = "/home";

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends BaseState<HomePage> {
  HomeBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_bloc == null) {
      _bloc = BlocProvider.of<HomeBloc>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AppPage(
          key: const Key("HomePage"),
          retryOnTap: () {},
          initStateStream: _bloc!.stream.map((s) => s.isInitCompleted),
          processStateStream: _bloc!.stream.map((s) => s.processState),
          title: S.current.titleHome,
          isCountRequired: true,
          child: _getBodyLayout(context, state),
        );
      },
    );
  }

  Widget _getBodyLayout(
    BuildContext context,
    HomeState state,
  ) {
    return Container();
  }
}
