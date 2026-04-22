import 'package:mind_metric/src/application/bloc/splash/splash_event.dart';
import 'package:mind_metric/src/application/bloc/splash/splash_state.dart';
import 'package:mind_metric/src/application/core/base_bloc.dart';
import 'package:mind_metric/src/data/auth/auth_repository.dart';
import 'package:mind_metric/src/data/auth/user_repository.dart';

class SplashBloc extends BaseBloc<SplashEvent, SplashState, SplashUIEvent> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  SplashBloc({required this.authRepository, required this.userRepository})
      : super(SplashState()) {
    on<RedirectPage>(
      (event, emit) async {
        await Future.delayed(const Duration(milliseconds: 2000), () {});
        await authRepository.signOut();
        emit(state.copyWith(redirectToLogin: true));
      },
    );
  }

  @override
  SplashUIEvent get getEvent => SplashUIEvent();
}

class SplashUIEvent extends BaseUIEvent {}
