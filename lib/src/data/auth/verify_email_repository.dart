import 'package:mind_metric/src/data/auth/verify_email_service.dart';

/// Email verification: delegates to [VerifyEmailService] (REST).
class VerifyEmailRepository {
  VerifyEmailRepository({required VerifyEmailService service})
      : _service = service;

  final VerifyEmailService _service;

  Future<void> requestVerificationCode({required String email}) {
    return _service.sendVerificationCode(email: email);
  }

  Future<void> resendOTP({required String email}) {
    return _service.resendOTP(email: email);
  }

  Future<void> verifyCode({
    required String email,
    required String code,
  }) {
    return _service.verifyCode(email: email, code: code);
  }
}
