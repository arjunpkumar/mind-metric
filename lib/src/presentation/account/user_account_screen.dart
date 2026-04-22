import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_event.dart';
import 'package:mind_metric/src/application/bloc/account/account_state.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';
import 'package:mind_metric/src/presentation/account/widgets/account_confirmations_section.dart';
import 'package:mind_metric/src/presentation/account/widgets/account_create_button.dart';
import 'package:mind_metric/src/presentation/account/widgets/account_footer_section.dart';
import 'package:mind_metric/src/presentation/account/widgets/account_logo_header.dart';
import 'package:mind_metric/src/presentation/account/widgets/account_synced_text_fields.dart';
import 'package:mind_metric/src/presentation/account/widgets/account_tab_switcher.dart';
import 'package:mind_metric/src/presentation/auth/login/login_page.dart';
import 'package:mind_metric/src/presentation/auth/verify_email/verify_email_page.dart';

/// Dark create-account layout; stateless shell — all interactions go through [AccountBloc].
class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: accountScreenTheme(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AccountThemeColors.background,
          body: BlocConsumer<AccountBloc, AccountState>(
            listenWhen: (p, c) =>
                p.activeTab != c.activeTab ||
                p.accountCreationStatus != c.accountCreationStatus,
            listener: (context, state) {
              if (state.activeTab == AccountTab.logIn) {
                Navigator.of(context).pushNamed(LoginPage.route);
                context.read<AccountBloc>().add(
                      const AccountTabChanged(AccountTab.createAccount),
                    );
              }
              if (state.accountCreationStatus ==
                  AccountCreationStatus.success) {
                Navigator.of(context).pushNamed(
                  VerifyEmailPage.route,
                  arguments: VerifyEmailRouteArgs(
                    email: state.email,
                    accountBloc: context.read<AccountBloc>(),
                  ),
                );
                context
                    .read<AccountBloc>()
                    .add(const AccountCreationUiConsumed());
              } else if (state.accountCreationStatus ==
                  AccountCreationStatus.failure) {
                final msg = state.accountCreationErrorMessage ??
                    'Could not create account.';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AccountThemeColors.inputBackground,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AccountLogoHeader(),
                      const SizedBox(height: 24),
                      const Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Join The Big Skill Challenge™ to enter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AccountThemeColors.muted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const AccountTabSwitcher(),
                      const SizedBox(height: 24),
                      const AccountSyncedTextFields(),
                      const SizedBox(height: 24),
                      const Divider(
                        color: Color(0x33FFFFFF),
                        height: 1,
                      ),
                      const SizedBox(height: 24),
                      const AccountConfirmationsSection(),
                      const SizedBox(height: 28),
                      const AccountCreateButton(),
                      const SizedBox(height: 28),
                      AccountFooterSection(
                        onLogInTap: () {
                          Navigator.of(context).pushNamed(LoginPage.route);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
