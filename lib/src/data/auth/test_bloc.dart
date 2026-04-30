/// Created by Arjun P Kumar on 29-04-2026
/// File Name : test_bloc.dart
/// Project: Ahoy
/// Description:

import 'package:mind_metric/src/data/auth/auth_repository.dart';

class LoginBloc {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository);

  void onLoginPressed(String email, String password) {
    // This call to 'signIn' is the "error" we want the AI to catch
    authRepository.signTest(email, password);
  }
}
