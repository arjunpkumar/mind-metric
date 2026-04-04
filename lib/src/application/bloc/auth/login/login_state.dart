import 'package:equatable/equatable.dart';

class _Unset {
  const _Unset();
}

const Object _unset = _Unset();

enum LoginFormStatus {
  pure,
  validating,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginFormStatus.pure,
    this.emailError,
    this.passwordError,
    this.submissionErrorMessage,
  });

  final String email;
  final String password;
  final LoginFormStatus status;
  final String? emailError;
  final String? passwordError;
  final String? submissionErrorMessage;

  factory LoginState.initial() => const LoginState();

  LoginState copyWith({
    String? email,
    String? password,
    LoginFormStatus? status,
    Object? emailError = _unset,
    Object? passwordError = _unset,
    Object? submissionErrorMessage = _unset,
    bool clearSubmissionError = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      emailError: identical(emailError, _unset)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _unset)
          ? this.passwordError
          : passwordError as String?,
      submissionErrorMessage: clearSubmissionError
          ? null
          : identical(submissionErrorMessage, _unset)
              ? this.submissionErrorMessage
              : submissionErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        emailError,
        passwordError,
        submissionErrorMessage,
      ];
}
