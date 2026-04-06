import 'package:mind_metric/src/application/bloc/account/account_state.dart';

abstract class AccountEvent {
  const AccountEvent();
}

class AccountTabChanged extends AccountEvent {
  const AccountTabChanged(this.tab);

  final AccountTab tab;
}

class AccountEmailChanged extends AccountEvent {
  const AccountEmailChanged(this.email);

  final String email;
}

class AccountPasswordChanged extends AccountEvent {
  const AccountPasswordChanged(this.password);

  final String password;
}

class AccountAgeConfirmationChanged extends AccountEvent {
  const AccountAgeConfirmationChanged(this.confirmed);

  final bool confirmed;
}

class AccountTermsConfirmationChanged extends AccountEvent {
  const AccountTermsConfirmationChanged(this.confirmed);

  final bool confirmed;
}

class SubmitAccountCreation extends AccountEvent {
  const SubmitAccountCreation();
}

/// Clears [AccountCreationStatus.success] after the UI has shown feedback.
class AccountCreationUiConsumed extends AccountEvent {
  const AccountCreationUiConsumed();
}
