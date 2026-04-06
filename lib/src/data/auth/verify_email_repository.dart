import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/data/auth/verify_email_service.dart';

/// Email verification: delegates to [VerifyEmailService] (REST).
class VerifyEmailRepository {
  VerifyEmailRepository({required VerifyEmailService service})
      : _service = service;

  final VerifyEmailService _service;

  Future<void> requestVerificationCode({required String email}) {
    if (kBypassVerifyEmailNetwork) {
      return Future<void>.value();
    }
    return _service.sendVerificationCode(email: email);
  }

  Future<void> verifyCode({
    required String email,
    required String code,
  }) {
    if (kBypassVerifyEmailNetwork) {
      return Future<void>.value();
    }
    return _service.verifyCode(email: email, code: code);
  }
}
