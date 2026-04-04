import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_event.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_state.dart';
import 'package:mind_metric/src/data/auth/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(LoginState.initial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginRepository _loginRepository;

  static final RegExp _emailPattern = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final error = _validateEmailRealtime(event.email);
    emit(
      state.copyWith(
        email: event.email,
        emailError: error,
        clearSubmissionError: true,
        status: LoginFormStatus.pure,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final error = _validatePasswordRealtime(event.password);
    emit(
      state.copyWith(
        password: event.password,
        passwordError: error,
        clearSubmissionError: true,
        status: LoginFormStatus.pure,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final emailErr = _validateEmailSubmit(state.email);
    final passErr = _validatePasswordSubmit(state.password);
    if (emailErr != null || passErr != null) {
      emit(
        state.copyWith(
          status: LoginFormStatus.validating,
          emailError: emailErr,
          passwordError: passErr,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: LoginFormStatus.submissionInProgress,
        clearSubmissionError: true,
      ),
    );

    try {
      await _loginRepository.logIn(
        email: state.email.trim(),
        password: state.password,
      );
      emit(state.copyWith(status: LoginFormStatus.submissionSuccess));
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Something went wrong';
      emit(
        state.copyWith(
          status: LoginFormStatus.submissionFailure,
          submissionErrorMessage: message,
        ),
      );
    }
  }

  String? _validateEmailRealtime(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateEmailSubmit(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Email is required';
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePasswordRealtime(String value) {
    if (value.isEmpty) {
      return null;
    }
    return null;
  }

  String? _validatePasswordSubmit(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
