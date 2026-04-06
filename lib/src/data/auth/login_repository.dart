import 'dart:math';

import 'package:mind_metric/src/core/app_constants.dart';

/// Simulates a login API for the login screen BLoC.
class LoginRepository {
  LoginRepository({Random? random}) : _random = random ?? Random();

  final Random _random;

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (kBypassLoginNetwork) {
      return;
    }
    if (_random.nextBool()) {
      return;
    }
    throw Exception('Invalid credentials');
  }
}
