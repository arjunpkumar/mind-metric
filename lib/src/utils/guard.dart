import 'package:flutter/foundation.dart';
import 'package:flutter_base/src/utils/error_logger.dart';

/// Created by Jemsheer K D on 15 September, 2023.
/// File Name : guard
/// Project : FlutterBase

class Guard {
  Guard._();

  static T withDefault<T>(T Function() fun, {required T defaultValue}) {
    try {
      return fun();
    } catch (e, s) {
      debugPrint(e.toString());
      ErrorLogger().recordError(exception: e, stackTrace: s);
    }
    return defaultValue;
  }

  static T? asNullable<T>(T? Function() fun) {
    try {
      return fun();
    } catch (e, s) {
      debugPrint(e.toString());
      ErrorLogger().recordError(exception: e, stackTrace: s);
    }
    return null;
  }

  static Future<T?> asNullableAsync<T>(Future<T?> Function() fun) async {
    try {
      return fun();
    } catch (e, s) {
      debugPrint(e.toString());
      ErrorLogger().recordError(exception: e, stackTrace: s);
    }
    return null;
  }

  static Future<T> withDefaultAsync<T>(
    Future<T> Function() fun, {
    required T defaultValue,
  }) async {
    try {
      return fun();
    } catch (e, s) {
      debugPrint(e.toString());
      ErrorLogger().recordError(exception: e, stackTrace: s);
    }
    return defaultValue;
  }

  static void run(Function() fun) {
    try {
      fun();
    } catch (e, s) {
      debugPrint(e.toString());
      ErrorLogger().recordError(exception: e, stackTrace: s);
    }
  }

  static Future<void> runAsync(Function() fun) async {
    try {
      await fun();
    } catch (e, s) {
      debugPrint(e.toString());
      ErrorLogger().recordError(exception: e, stackTrace: s);
    }
  }
}
