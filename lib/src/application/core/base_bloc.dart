import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thinkhub/src/application/core/base_bloc_event.dart';
import 'package:thinkhub/src/application/core/base_bloc_state.dart';
import 'package:thinkhub/src/application/core/process_state.dart';

abstract class BaseBloc<Event extends BaseBlocEvent,
    State extends BaseBlocState> extends Bloc<Event, State> {
  final processState = BehaviorSubject<ProcessState>();

  BaseBloc(super.initialState);

  void dispose() {
    processState.close();
  }
}
