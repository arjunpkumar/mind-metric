import 'package:flutter/material.dart';
import 'package:mind_metric/src/application/bloc/splash/splash_bloc.dart';
import 'package:mind_metric/src/application/bloc/splash/splash_event.dart';
import 'package:mind_metric/src/application/bloc/splash/splash_state.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/presentation/core/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  static String route = '/';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashState();
}

class _SplashState extends BaseState<SplashPage> {
  SplashBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = BlocProvider.of<SplashBloc>(context);
      _bloc!.add(RedirectPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        /*if (state.redirectToLogin ?? false) {
          Navigator.pushReplacementNamed(context, LoginPage.route);
        }*/
      },
      builder: (context, state) {
        final width = MediaQuery.of(context).size.width;

        return Scaffold(
          body: Center(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    width > 600 ? AppIcons.kBgLandscape : AppIcons.kBgImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(child: _appLogo()),
            ),
          ),
        );
      },
    );
  }

  Widget _appLogo() {
    return Image.asset(
      AppIcons.kAppLogo,
      fit: BoxFit.contain,
      width: 150,
    );
  }
}
