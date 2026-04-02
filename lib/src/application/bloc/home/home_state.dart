import 'package:mind_metric/src/application/core/base_bloc_state.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : home_state
/// Project : FlutterBase

class HomeState extends BaseBlocState {
  String dummy = "";

  HomeState({
    this.dummy = "",
  });

  @override
  HomeState copyWith({
    String? dummy,
  }) {
    return HomeState(
      dummy: dummy ?? this.dummy,
    )
      ..processState = processState
      ..isInitCompleted = isInitCompleted;
  }
}
