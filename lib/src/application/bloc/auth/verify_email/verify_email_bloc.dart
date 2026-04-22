import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/verify_email/verify_email_event.dart';
import 'package:mind_metric/src/application/bloc/auth/verify_email/verify_email_state.dart';
import 'package:mind_metric/src/data/auth/verify_email_repository.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  VerifyEmailBloc({
    required VerifyEmailRepository repository,
    required this.email,
  })  : _repository = repository,
        super(const VerifyEmailState()) {
    on<VerifyEmailOtpUpdated>(_onOtpUpdated);
    on<VerifyEmailSubmitted>(_onSubmitted);
    on<VerifyEmailResendRequested>(_onResend);
    on<VerifyEmailResendTick>(_onResendTick);
    on<VerifyEmailInitialSendRequested>(_onInitialSend);
    Future.microtask(() => add(const VerifyEmailInitialSendRequested()));
  }

  final VerifyEmailRepository _repository;
  final String email;

  static const int _resendCooldown = 45;

  void _onOtpUpdated(
    VerifyEmailOtpUpdated event,
    Emitter<VerifyEmailState> emit,
  ) {
    final digits = event.code.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > 6 ? digits.substring(0, 6) : digits;
    emit(
      state.copyWith(
        otpCode: clipped,
        clearError: true,
        clearSendError: true,
        status: VerifyEmailStatus.idle,
      ),
    );
  }

  Future<void> _onSubmitted(
    VerifyEmailSubmitted event,
    Emitter<VerifyEmailState> emit,
  ) async {
    if (state.otpCode.length != 6) {
      emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: 'Enter the 6-digit code',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: VerifyEmailStatus.verifying,
        clearError: true,
      ),
    );

    try {
      await _repository.verifyCode(email: email, code: state.otpCode);
      emit(state.copyWith(status: VerifyEmailStatus.success));
    } catch (e) {
      final msg = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Something went wrong';
      emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: msg,
        ),
      );
    }
  }

  Future<void> _onResend(
    VerifyEmailResendRequested event,
    Emitter<VerifyEmailState> emit,
  ) async {
    if (!state.canResend) {
      return;
    }
    try {
      await _repository.resendOTP(email: email);
      emit(
        state.copyWith(
          resendCooldownSeconds: _resendCooldown,
          clearSendError: true,
        ),
      );
      _scheduleResendTick();
    } catch (e) {
      final msg = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Could not resend code. Try again later.';
      emit(state.copyWith(sendErrorMessage: msg));
    }
  }

  Future<void> _onInitialSend(
    VerifyEmailInitialSendRequested event,
    Emitter<VerifyEmailState> emit,
  ) async {
    emit(state.copyWith(initialSendInProgress: true, clearSendError: true));
    try {
      await _repository.requestVerificationCode(email: email);
      emit(state.copyWith(initialSendInProgress: false));
    } catch (e) {
      final msg = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Could not send verification email.';
      emit(
        state.copyWith(
          initialSendInProgress: false,
          sendErrorMessage: msg,
        ),
      );
    }
  }

  void _scheduleResendTick() {
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        add(const VerifyEmailResendTick());
      }
    });
  }

  void _onResendTick(
    VerifyEmailResendTick event,
    Emitter<VerifyEmailState> emit,
  ) {
    if (state.resendCooldownSeconds <= 0) {
      return;
    }
    final next = state.resendCooldownSeconds - 1;
    emit(state.copyWith(resendCooldownSeconds: next));
    if (next > 0) {
      _scheduleResendTick();
    }
  }
}
