import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_event.dart';
import 'package:mind_metric/src/application/bloc/account/account_state.dart';
import 'package:mind_metric/src/data/account/account_repository.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({required AccountRepository accountRepository})
      : _accountRepository = accountRepository,
        super(AccountState.initial()) {
    on<AccountTabChanged>(_onTabChanged);
    on<AccountEmailChanged>(_onEmailChanged);
    on<AccountPasswordChanged>(_onPasswordChanged);
    on<AccountAgeConfirmationChanged>(_onAgeChanged);
    on<AccountTermsConfirmationChanged>(_onTermsChanged);
    on<SubmitAccountCreation>(_onSubmit);
    on<AccountCreationUiConsumed>(_onUiConsumed);
  }

  final AccountRepository _accountRepository;

  static final RegExp _emailPattern = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  void _onTabChanged(
    AccountTabChanged event,
    Emitter<AccountState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }

  void _onEmailChanged(
    AccountEmailChanged event,
    Emitter<AccountState> emit,
  ) {
    emit(
      state.copyWith(
        email: event.email,
        emailError: _validateEmailRealtime(event.email),
        accountCreationErrorMessage: null,
        accountCreationStatus: AccountCreationStatus.idle,
      ),
    );
  }

  void _onPasswordChanged(
    AccountPasswordChanged event,
    Emitter<AccountState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        passwordError: _validatePasswordRealtime(event.password),
        accountCreationErrorMessage: null,
        accountCreationStatus: AccountCreationStatus.idle,
      ),
    );
  }

  void _onAgeChanged(
    AccountAgeConfirmationChanged event,
    Emitter<AccountState> emit,
  ) {
    emit(
      state.copyWith(
        ageConfirmed: event.confirmed,
        accountCreationStatus: AccountCreationStatus.idle,
        accountCreationErrorMessage: null,
      ),
    );
  }

  void _onTermsChanged(
    AccountTermsConfirmationChanged event,
    Emitter<AccountState> emit,
  ) {
    emit(
      state.copyWith(
        termsConfirmed: event.confirmed,
        accountCreationStatus: AccountCreationStatus.idle,
        accountCreationErrorMessage: null,
      ),
    );
  }

  Future<void> _onSubmit(
    SubmitAccountCreation event,
    Emitter<AccountState> emit,
  ) async {
    final emailErr = _validateEmailSubmit(state.email);
    final passErr = _validatePasswordSubmit(state.password);

    if (emailErr != null ||
        passErr != null ||
        !state.ageConfirmed ||
        !state.termsConfirmed) {
      emit(
        state.copyWith(
          emailError: emailErr,
          passwordError: passErr,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        accountCreationStatus: AccountCreationStatus.loading,
        accountCreationErrorMessage: null,
      ),
    );

    try {
      await _accountRepository.createAccount(
        email: state.email.trim(),
        password: state.password,
      );
      emit(
        state.copyWith(
          accountCreationStatus: AccountCreationStatus.success,
          email: state.email.trim(),
          password: state.password,
          ageConfirmed: false,
          termsConfirmed: false,
          emailError: null,
          passwordError: null,
          accountCreationErrorMessage: null,
        ),
      );
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Something went wrong';
      emit(
        state.copyWith(
          accountCreationStatus: AccountCreationStatus.failure,
          accountCreationErrorMessage: message,
        ),
      );
    }
  }

  void _onUiConsumed(
    AccountCreationUiConsumed event,
    Emitter<AccountState> emit,
  ) {
    if (state.accountCreationStatus == AccountCreationStatus.success) {
      emit(state.copyWith(accountCreationStatus: AccountCreationStatus.idle));
    }
  }

  String? _validateEmailRealtime(String value) {
    final t = value.trim();
    if (t.isEmpty) {
      return null;
    }
    if (!_emailPattern.hasMatch(t)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateEmailSubmit(String value) {
    final t = value.trim();
    if (t.isEmpty) {
      return 'Email is required';
    }
    if (!_emailPattern.hasMatch(t)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePasswordRealtime(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validatePasswordSubmit(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
