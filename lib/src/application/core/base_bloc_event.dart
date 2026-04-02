import 'package:mind_metric/src/application/core/process_state.dart';

abstract class BaseBlocEvent {
  ProcessState processState = ProcessState.initial();
}
