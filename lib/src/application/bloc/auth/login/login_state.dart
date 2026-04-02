import 'package:mind_metric/src/application/core/base_bloc_state.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : login_state
/// Project : FlutterBase

class LoginState extends BaseBlocState {
  String dummy = "";

  LoginState({
    this.dummy = "",
  });

  @override
  LoginState copyWith({
    String? dummy,
  }) {
    return LoginState(
      dummy: dummy ?? this.dummy,
    )
      ..processState = processState
      ..canPop = canPop
      ..isInitCompleted = isInitCompleted;
  }
}
