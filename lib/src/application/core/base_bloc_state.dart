import 'package:flutter_base/src/application/core/process_state.dart';

abstract class BaseBlocState {
  ProcessState processState = ProcessState.initial();
  bool canPop = true;
  // ignore: always_declare_return_types
  BaseBlocState copyWith();
}
