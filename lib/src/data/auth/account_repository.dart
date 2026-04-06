import 'dart:math';

import 'package:mind_metric/src/core/app_constants.dart';

/// Mock account creation API for [AccountBloc].
class AccountRepository {
  AccountRepository({Random? random}) : _random = random ?? Random();

  final Random _random;

  Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (kBypassAccountCreationNetwork) {
      return;
    }
    if (_random.nextBool()) {
      return;
    }
    throw Exception('Unable to create account. Please try again.');
  }
}
