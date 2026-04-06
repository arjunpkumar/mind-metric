import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/application/bloc/splash/splash_bloc.dart';
import 'package:mind_metric/src/application/bloc/splash/splash_event.dart';
import 'package:mind_metric/src/application/bloc/splash/splash_state.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/presentation/core/base_state.dart';
import 'package:mind_metric/src/presentation/core/theme/colors.dart';
import 'package:mind_metric/src/presentation/core/theme/text_styles.dart';
import 'package:mind_metric/src/presentation/home/home_page.dart';
import 'package:mind_metric/src/presentation/landing/landing_page.dart';

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
        if (state.redirectToOtp ?? false) {
          Navigator.pushReplacementNamed(context, HomePage.route);
          return;
        }
        if (state.redirectToLogin ?? false) {
          Navigator.pushReplacementNamed(context, LandingPage.route);
        }
      },
      builder: (context, state) {
        final width = MediaQuery.sizeOf(context).width;
        final logoWidth = (width * 0.42).clamp(140.0, 240.0);

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.denimBlue,
                  AppColors.denim,
                  AppColors.extraLightBlueShade,
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  SvgPicture.asset(
                    AppIcons.kHeadsLogoSvg,
                    width: logoWidth,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    S.of(context).titleApp,
                    textAlign: TextAlign.center,
                    style: TextStyles.h2Bold(context)?.copyWith(
                      color: AppColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(flex: 3),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white.withOpacity(0.92),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
