import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/home/home_event.dart';
import 'package:mind_metric/src/application/bloc/home/home_state.dart';
import 'package:mind_metric/src/application/core/base_bloc.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : home_bloc
/// Project : FlutterBase

class HomeBloc extends BaseBloc<HomeEvent, HomeState, HomeUIEvent> {
  HomeBloc() : super(HomeState()) {
    on<HomeInit>(
      (event, emit) => _onInit(event, emit),
    );

    add(HomeInit());
  }

  void _onInit(
    HomeInit event,
    Emitter<HomeState> emit,
  ) {}

  @override
  HomeUIEvent get getEvent => HomeUIEvent();
}

class HomeUIEvent extends BaseUIEvent {}
