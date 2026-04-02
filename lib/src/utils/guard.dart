import 'package:flutter/foundation.dart';
import 'package:mind_metric/src/utils/error_logger.dart';

/// Created by Jemsheer K D on 15 September, 2023.
/// File Name : guard
/// Project : FlutterBase

class Guard {
  Guard._();

  static T withDefault<T>(
    T Function() fun, {
    required T defaultValue,
    Function(Object, StackTrace)? onError,
    bool canSkipErrorLog = false,
    String? prefix,
  }) {
    try {
      return fun();
    } catch (e, s) {
      debugPrint(prefix != null ? "$prefix: $e" : e.toString());
      if (!canSkipErrorLog) {
        ErrorLogger().recordError(exception: e, stackTrace: s);
      }
      onError?.call(e, s);
    }
    return defaultValue;
  }

  static T? asNullable<T>(
    T? Function() fun, {
    Function(Object, StackTrace)? onError,
    bool canSkipErrorLog = false,
    String? prefix,
  }) {
    try {
      return fun();
    } catch (e, s) {
      debugPrint(prefix != null ? "$prefix: $e" : e.toString());
      if (!canSkipErrorLog) {
        ErrorLogger().recordError(exception: e, stackTrace: s);
      }
      onError?.call(e, s);
    }
    return null;
  }

  static Future<T?> asNullableAsync<T>(
    Future<T?> Function() fun, {
    Function(Object, StackTrace)? onError,
    bool canSkipErrorLog = false,
    String? prefix,
  }) async {
    try {
      return await fun();
    } catch (e, s) {
      debugPrint(prefix != null ? "$prefix: $e" : e.toString());
      if (!canSkipErrorLog) {
        ErrorLogger().recordError(exception: e, stackTrace: s);
      }
      onError?.call(e, s);
    }
    return null;
  }

  static Future<T> withDefaultAsync<T>(
    Future<T> Function() fun, {
    required T defaultValue,
    Function(Object, StackTrace)? onError,
    bool canSkipErrorLog = false,
    String? prefix,
  }) async {
    try {
      return await fun();
    } catch (e, s) {
      debugPrint(prefix != null ? "$prefix: $e" : e.toString());
      if (!canSkipErrorLog) {
        ErrorLogger().recordError(exception: e, stackTrace: s);
      }
      onError?.call(e, s);
    }
    return defaultValue;
  }

  static void run(
    Function() fun, {
    Function(Object, StackTrace)? onError,
    bool canSkipErrorLog = false,
    String? prefix,
  }) {
    try {
      fun();
    } catch (e, s) {
      debugPrint(prefix != null ? "$prefix: $e" : e.toString());
      if (!canSkipErrorLog) {
        ErrorLogger().recordError(exception: e, stackTrace: s);
      }
      onError?.call(e, s);
    }
  }

  static Future<void> runAsync(
    Function() fun, {
    Function(Object, StackTrace)? onError,
    bool canSkipErrorLog = false,
    String? prefix,
  }) async {
    try {
      await fun();
    } catch (e, s) {
      debugPrint(prefix != null ? "$prefix: $e" : e.toString());
      if (!canSkipErrorLog) {
        ErrorLogger().recordError(exception: e, stackTrace: s);
      }
      onError?.call(e, s);
    }
  }
}
