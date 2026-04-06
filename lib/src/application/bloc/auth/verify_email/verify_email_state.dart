import 'package:equatable/equatable.dart';

enum VerifyEmailStatus { idle, verifying, success, failure }

class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    this.otpCode = '',
    this.status = VerifyEmailStatus.idle,
    this.errorMessage,
    this.resendCooldownSeconds = 0,
    this.initialSendInProgress = false,
    this.sendErrorMessage,
  });

  final String otpCode;
  final VerifyEmailStatus status;
  final String? errorMessage;
  final int resendCooldownSeconds;
  final bool initialSendInProgress;
  final String? sendErrorMessage;

  bool get canVerify =>
      otpCode.length == 6 &&
      status != VerifyEmailStatus.verifying &&
      status != VerifyEmailStatus.success;

  bool get canResend =>
      !initialSendInProgress &&
      resendCooldownSeconds == 0 &&
      status != VerifyEmailStatus.verifying;

  VerifyEmailState copyWith({
    String? otpCode,
    VerifyEmailStatus? status,
    String? errorMessage,
    int? resendCooldownSeconds,
    bool? initialSendInProgress,
    String? sendErrorMessage,
    bool clearError = false,
    bool clearSendError = false,
  }) {
    return VerifyEmailState(
      otpCode: otpCode ?? this.otpCode,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      resendCooldownSeconds: resendCooldownSeconds ?? this.resendCooldownSeconds,
      initialSendInProgress:
          initialSendInProgress ?? this.initialSendInProgress,
      sendErrorMessage: clearSendError
          ? null
          : (sendErrorMessage ?? this.sendErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        otpCode,
        status,
        errorMessage,
        resendCooldownSeconds,
        initialSendInProgress,
        sendErrorMessage,
      ];
}
