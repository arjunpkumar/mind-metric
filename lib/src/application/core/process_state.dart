import 'package:mind_metric/generated/l10n.dart';

enum ProcessStatus { initial, busy, completed, error }

class ProcessState {
  final ProcessStatus status;
  final String? errorMsg;
  final String? message;

  ProcessState._(this.status, this.errorMsg, this.message);

  ProcessState.initial({
    this.errorMsg,
    this.message,
  }) : status = ProcessStatus.initial;

  ProcessState.busy({
    this.errorMsg,
    this.message,
  }) : status = ProcessStatus.busy;

  ProcessState.completed({
    this.errorMsg,
    this.message,
  }) : status = ProcessStatus.completed;

  ProcessState.error({
    this.errorMsg,
    this.message,
  }) : status = ProcessStatus.error;

  ProcessState.noNetwork()
      : status = ProcessStatus.error,
        message = S.current.labelNoConnection,
        errorMsg = S.current.labelPleaseCheckYourInternetConnection;

  ProcessState.noData()
      : status = ProcessStatus.error,
        message = S.current.labelNoData,
        errorMsg = "";
}
