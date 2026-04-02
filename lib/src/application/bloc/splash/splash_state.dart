import 'package:mind_metric/src/application/core/base_bloc_state.dart';

class SplashState extends BaseBlocState {
  SplashState({
    this.redirectToLogin = false,
    this.redirectToOtp = false,
  });

  bool? redirectToLogin;
  bool? redirectToOtp;

  @override
  SplashState copyWith({bool? redirectToLogin, bool? redirectToOtp}) {
    return SplashState(
      redirectToLogin: redirectToLogin ?? this.redirectToLogin,
      redirectToOtp: redirectToOtp ?? this.redirectToOtp,
    );
  }
}
