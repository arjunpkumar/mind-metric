import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/config.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/src/application/core/base_bloc_event.dart';
import 'package:flutter_base/src/application/core/base_bloc_state.dart';
import 'package:flutter_base/src/application/core/process_state.dart';
import 'package:flutter_base/src/core/exceptions.dart';
import 'package:flutter_base/src/utils/network_validator.dart';
import 'package:flutter_base/src/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

abstract class BaseBloc<
    Event extends BaseBlocEvent,
    State extends BaseBlocState,
    UIEvent extends BaseUIEvent> extends Bloc<Event, State> {
  final _event = PublishSubject<UIEvent>();
  final _message = PublishSubject<Tuple2<String, int>>();
  final _dialogMessage = PublishSubject<String>();
  final _noNetworkError = PublishSubject<void>();
  bool _isDisposed = false;

  BaseBloc(super.initialState);

  Stream<UIEvent> get eventStream => _event;

  UIEvent get getEvent;

  void publish(UIEvent event) {
    if (!_event.isClosed) _event.add(event);
  }

  Stream<Tuple2<String, int>> get message => _message;

  Stream<String> get dialogMessage => _dialogMessage;

  void showMessage(String message, {int seconds = 1}) {
    if (!_message.isClosed) _message.add(Tuple2(message, seconds));
  }

  void showMessageDialog(String? message) {
    if (!_dialogMessage.isClosed && StringUtils.isNotNullAndEmpty(message)) {
      _dialogMessage.add(message!);
    }
  }

  Stream<void> get noNetworkError => _noNetworkError;

  bool get isDisposed => _isDisposed;

  @override
  Future<void> close() {
    _event.close();
    _message.close();
    _dialogMessage.close();
    _noNetworkError.close();
    _isDisposed = true;
    return super.close();
  }

  Future<void> handleAPICall(
    NetworkValidator networkValidator,
    Future Function() fun, {
    Function(Object, StackTrace)? onError,
    String? errorMessage,
    bool isNetworkCheckNeeded = true,
    bool shouldShowDialogForAPIFailedException = true,
  }) async {
    try {
      if (isNetworkCheckNeeded) {
        await networkValidator.validateNetworkReachability();
      }
      await fun();
    } catch (e, s) {
      if (e is NoNetworkException) {
        showMessage(S.current.labelNoNetworkAvailable);
      } else if (e is APIFailedException) {
        if (shouldShowDialogForAPIFailedException) {
          showMessageDialog(e.message);
        } else {
          e.message != null
              ? showMessage(e.message!)
              : showMessage(S.current.labelSomethingWentWrong);
        }
      } else {
        showMessage(errorMessage ?? S.current.labelSomethingWentWrong);
      }
      if ((Config.appFlavor is Production ||
              Config.appFlavor is Staging ||
              Config.appFlavor is QA ||
              Config.appFlavor is Development) ||
          (e is! APIFailedException && e is! NoNetworkException)) {
        debugPrint("$e\n$s");
      }
      onError?.call(e, s);
    }
  }

  void handleAPIException(
    Emitter<BaseBlocState> emit,
    BaseBlocState state,
    Object e, {
    bool showNoNetworkPageIfNeeded = false,
  }) {
    emit(
      state
        ..isInitCompleted = true
        ..processState = e is NoNetworkException && showNoNetworkPageIfNeeded
            ? ProcessState.noNetwork()
            : ProcessState.completed(),
    );
  }
}

abstract class BaseUIEvent {}
