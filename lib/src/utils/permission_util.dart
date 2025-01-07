import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/src/core/app.dart';
import 'package:permission_handler/permission_handler.dart';

/// Created by Jemsheer K D on 21 November, 2023.
/// File Name : permission_util
/// Project : FlutterBase

class PermissionUtil {
  static void showOpenSettingsSnackBar(String message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  }

  Future<bool> checkAndRequestPermission(
    Permission permission,
    String message,
  ) async {
    final currentStatus = await permission.status;
    if (currentStatus != PermissionStatus.granted) {
      final status = await permission.request();
      if (![
        PermissionStatus.granted,
        PermissionStatus.limited,
      ].contains(status)) {
        if (Platform.isAndroid) {
          if (await permission.shouldShowRequestRationale) {
            final updatedStatus = await permission.status;
            return [
              PermissionStatus.granted,
              PermissionStatus.limited,
            ].contains(updatedStatus);
          } else {
            showOpenSettingsSnackBar(message);
          }
        } else if (Platform.isIOS) {
          showOpenSettingsSnackBar(message);
        }
        return false;
      }
    }
    return true;
  }
}
