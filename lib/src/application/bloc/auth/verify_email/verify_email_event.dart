abstract class VerifyEmailEvent {
  const VerifyEmailEvent();
}

class VerifyEmailOtpUpdated extends VerifyEmailEvent {
  const VerifyEmailOtpUpdated(this.code);

  final String code;
}

class VerifyEmailSubmitted extends VerifyEmailEvent {
  const VerifyEmailSubmitted();
}

class VerifyEmailResendRequested extends VerifyEmailEvent {
  const VerifyEmailResendRequested();
}

/// Dispatched once when the verify screen opens to request the first code email.
class VerifyEmailInitialSendRequested extends VerifyEmailEvent {
  const VerifyEmailInitialSendRequested();
}

class VerifyEmailResendTick extends VerifyEmailEvent {
  const VerifyEmailResendTick();
}
