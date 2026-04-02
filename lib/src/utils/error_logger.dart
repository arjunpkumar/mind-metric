import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mind_metric/config.dart';
import 'package:mind_metric/src/core/app.dart';
import 'package:mind_metric/src/presentation/widgets/dialog/app_dialog.dart';

class ErrorLogger {
  static ErrorLogger? _instance;
  late FirebaseCrashlytics _crashlytics;

  factory ErrorLogger() {
    return _instance ??= ErrorLogger._();
  }

  ///Should Only Be Used for writing Unit Test Cases
  ///[instance] needs to be a mocked instance of ErrorLogger
  @visibleForTesting
  factory ErrorLogger.fromMock(ErrorLogger instance) {
    return _instance = instance;
  }

  ErrorLogger._() {
    _crashlytics = FirebaseCrashlytics.instance;
  }

  void recordError({
    dynamic exception,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    if (fatal && Config.appFlavor is! Production) {
      openAppDialog(
        navigatorKey.currentContext!,
        title: exception.toString(),
        content: stackTrace.toString(),
      ).then((value) {
        _logError(exception, stackTrace, fatal);
      });
    } else {
      _logError(exception, stackTrace, fatal);
    }
  }

  void _logError(dynamic exception, StackTrace? stackTrace, bool fatal) {
    if (exception is StateError) {
      if (exception.message ==
          'Bad state: Cannot add new events after calling close') {
        return;
      }
    }
    _crashlytics.recordError(exception, stackTrace, fatal: fatal);
  }
}
