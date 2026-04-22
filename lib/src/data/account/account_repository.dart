import 'package:mind_metric/src/data/account/account_service.dart';

class AccountRepository {
  AccountRepository({required AccountService accountService})
      : _accountService = accountService;

  final AccountService _accountService;

  Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    await _accountService.register(
      email: email,
      password: password,
    );
  }
}
