/// Base event for [LoginBloc].
abstract class LoginEvent {
  const LoginEvent();
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
