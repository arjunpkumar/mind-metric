import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/home/home_bloc.dart';
import 'package:mind_metric/src/application/bloc/web_view/web_view_bloc.dart';
import 'package:mind_metric/src/application/core/bloc_provider.dart';
import 'package:mind_metric/src/presentation/account/account_page.dart';
import 'package:mind_metric/src/presentation/auth/login/login_page.dart';
import 'package:mind_metric/src/presentation/auth/verify_email/verify_email_page.dart';
import 'package:mind_metric/src/presentation/dashboard/dashboard_page.dart';
import 'package:mind_metric/src/presentation/home/home_page.dart';
import 'package:mind_metric/src/presentation/landing/landing_page.dart';
import 'package:mind_metric/src/presentation/quiz/creative_submission_page.dart';
import 'package:mind_metric/src/presentation/quiz/entry_submitted_page.dart';
import 'package:mind_metric/src/presentation/quiz/qualification_quiz_page.dart';
import 'package:mind_metric/src/presentation/quiz/quiz_success_page.dart';
import 'package:mind_metric/src/presentation/quiz/quiz_time_expired_page.dart';
import 'package:mind_metric/src/presentation/splash/splash_page.dart';
import 'package:mind_metric/src/presentation/web_view/web_view_page.dart';

final Map<String, Widget Function(BuildContext context)> routes = {
  SplashPage.route: (_) => BlocProvider(
        create: (_) => provideSplashBloc(),
        child: const SplashPage(),
      ),
  LoginPage.route: (_) => const LoginPage(),
  LandingPage.route: (_) => const LandingPage(),
  AccountPage.route: (_) => const AccountPage(),
  HomePage.route: (_) => BlocProvider(
        create: (_) => HomeBloc(),
        child: const HomePage(),
      ),
  QualificationQuizPage.route: (_) => const QualificationQuizPage(),
  QuizSuccessPage.route: (_) => const QuizSuccessPage(),
  CreativeSubmissionPage.route: (_) => const CreativeSubmissionPage(),
  EntrySubmittedPage.route: (_) => const EntrySubmittedPage(),
  QuizTimeExpiredPage.route: (context) => QuizTimeExpiredPage(
        onReturnToCompetitionHome: () => Navigator.of(context).pop(),
      ),
};

Route<dynamic>? generatedRoutes(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? '');
  debugPrint("URI.PATH : ${uri.path}");
  debugPrint("URI.queryParams : ${uri.queryParameters}");
  debugPrint("Settings : ${settings.name}");
  debugPrint("Arguments :  ${settings.arguments ?? "null"}");

  switch (uri.path) {
    case VerifyEmailPage.route:
      final args = settings.arguments;
      String email = '';
      AccountBloc? accountBloc;
      if (args is VerifyEmailRouteArgs) {
        email = args.email;
        accountBloc = args.accountBloc;
      } else if (args is String) {
        email = args;
      }
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => VerifyEmailPage(
          email: email,
          accountBloc: accountBloc,
        ),
      );
    case WebViewPage.route:
      if (settings.arguments != null && settings.arguments is WebViewArgument) {
        return _getWebViewRoute(
          settings,
          settings.arguments! as WebViewArgument,
        );
      }
      return null;
    case DashboardPage.route:
      final args = settings.arguments;
      final a = args is DashboardRouteArgs
          ? args
          : const DashboardRouteArgs();
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => DashboardPage(
          userName: a.userName,
          shortlistedEntryRef: a.shortlistedEntryRef,
        ),
      );
  }
  return null;
}

MaterialPageRoute _getWebViewRoute(
  RouteSettings settings,
  WebViewArgument argument,
) {
  return MaterialPageRoute(
    builder: (context) => BlocProvider<WebViewBloc>(
      create: (context) => provideWebViewBloc(argument),
      child: const WebViewPage(),
    ),
    settings: settings,
  );
}
