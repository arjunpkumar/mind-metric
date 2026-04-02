import 'package:mind_metric/config.dart';
import 'package:mind_metric/src/utils/error_logger.dart';

class CustomException implements Exception {
  final String code;
  final String? message;

  CustomException(this.code, {this.message}) {
    if (Config.appFlavor is Production) {
      ErrorLogger().recordError(
        exception: this,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  String toString() {
    return '$code : $message';
  }
}

class FileNotExistsException implements Exception {
  final String filePath;

  FileNotExistsException({required this.filePath});
}

class NoNetworkException implements Exception {
  final String? message;

  NoNetworkException({this.message});
}

class NoPendingJobException implements Exception {
  NoPendingJobException();
}

class PendingJobException implements Exception {
  PendingJobException();
}

class APIFailedException implements Exception {
  final String? message;

  APIFailedException({this.message});
}
