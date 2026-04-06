import 'package:equatable/equatable.dart';

class _Unset {
  const _Unset();
}

const Object _fieldUnset = _Unset();

enum AccountTab { createAccount, logIn }

enum AccountCreationStatus { idle, loading, success, failure }

class AccountState extends Equatable {
  const AccountState({
    this.activeTab = AccountTab.createAccount,
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.ageConfirmed = false,
    this.termsConfirmed = false,
    this.accountCreationStatus = AccountCreationStatus.idle,
    this.accountCreationErrorMessage,
  });

  final AccountTab activeTab;
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool ageConfirmed;
  final bool termsConfirmed;
  final AccountCreationStatus accountCreationStatus;
  final String? accountCreationErrorMessage;

  factory AccountState.initial() => const AccountState();

  bool get canSubmitCreateAccount {
    if (accountCreationStatus == AccountCreationStatus.loading) {
      return false;
    }
    if (!ageConfirmed || !termsConfirmed) {
      return false;
    }
    final e = email.trim();
    if (e.isEmpty || password.isEmpty) {
      return false;
    }
    if (password.length < 8) {
      return false;
    }
    if (emailError != null || passwordError != null) {
      return false;
    }
    return true;
  }

  AccountState copyWith({
    AccountTab? activeTab,
    String? email,
    String? password,
    Object? emailError = _fieldUnset,
    Object? passwordError = _fieldUnset,
    bool? ageConfirmed,
    bool? termsConfirmed,
    AccountCreationStatus? accountCreationStatus,
    Object? accountCreationErrorMessage = _fieldUnset,
    bool resetAccountCreationFlow = false,
  }) {
    return AccountState(
      activeTab: activeTab ?? this.activeTab,
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: identical(emailError, _fieldUnset)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _fieldUnset)
          ? this.passwordError
          : passwordError as String?,
      ageConfirmed: ageConfirmed ?? this.ageConfirmed,
      termsConfirmed: termsConfirmed ?? this.termsConfirmed,
      accountCreationStatus: resetAccountCreationFlow
          ? AccountCreationStatus.idle
          : (accountCreationStatus ?? this.accountCreationStatus),
      accountCreationErrorMessage:
          identical(accountCreationErrorMessage, _fieldUnset)
              ? this.accountCreationErrorMessage
              : accountCreationErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        email,
        password,
        emailError,
        passwordError,
        ageConfirmed,
        termsConfirmed,
        accountCreationStatus,
        accountCreationErrorMessage,
      ];
}
