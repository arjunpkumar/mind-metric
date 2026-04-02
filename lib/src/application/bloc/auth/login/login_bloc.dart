import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_event.dart';
import 'package:mind_metric/src/application/bloc/auth/login/login_state.dart';
import 'package:mind_metric/src/application/core/base_bloc.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : login_bloc
/// Project : FlutterBase

class LoginBloc extends BaseBloc<LoginEvent, LoginState, LoginUIEvent> {
  LoginBloc() : super(LoginState()) {
    on<LoginInit>((event, emit) => _onInit(event, emit));

    add(LoginInit());
  }

  void _onInit(
    LoginInit event,
    Emitter<LoginState> emit,
  ) {}

  @override
  LoginUIEvent get getEvent => LoginUIEvent();
}

class LoginUIEvent extends BaseUIEvent {}
