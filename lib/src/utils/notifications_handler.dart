import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/application/model/notification_message.dart';
import 'package:mind_metric/src/core/app.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/data/auth/auth_repository.dart';
import 'package:mind_metric/src/data/auth/user_repository.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';
import 'package:mind_metric/src/presentation/widgets/dialog/app_dialog.dart';
import 'package:mind_metric/src/utils/deeplink_navigator.dart';
import 'package:mind_metric/src/utils/notification_util.dart';

enum NotificationMode { onLaunch, onResume, onMessage }

class NotificationsHandler {
  final FirebaseMessaging messagingService;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final DeeplinkNavigator navigator;
  final NotificationUtil notificationUtil;

  NotificationsHandler({
    required this.messagingService,
    required this.authRepository,
    required this.userRepository,
    required this.navigator,
    required this.notificationUtil,
  });

  void setup() {
    messagingService.getInitialMessage().then((message) async {
      if (message != null) {
        debugPrint(
          "Notification Opened Initial : ${message.notification?.title}",
        );
        final notification = NotificationMessage(message: message);
        await handleNotification(
          notification: notification,
          mode: NotificationMode.onLaunch,
        );
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = NotificationMessage(message: message);
      await handleNotification(
        notification: notification,
        mode: NotificationMode.onMessage,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      debugPrint("Notification Opened App : ${message.notification?.title}");
      final notification = NotificationMessage(message: message);
      await handleNotification(
        notification: notification,
        mode: NotificationMode.onResume,
      );
    });
  }

  Future<void> handleNotification({
    required NotificationMessage notification,
    required NotificationMode mode,
  }) async {
    // FlutterAppBadger.updateBadgeCount(notification.unreadCount);

    final isSessionActive = await authRepository.isSessionActive();
    if (!isSessionActive) {
      return;
    }

    if (mode != NotificationMode.onMessage) {
      await _handleDeeplink(notification, mode);
      return;
    }

    await _processNavigation(notification, mode);
  }

  Future<void> _handleDeeplink(
    NotificationMessage notification,
    NotificationMode mode,
  ) async {
    final user = await userRepository.getActiveUser();

    final navigationData = await notificationUtil.processNotificationDeeplink(
      user: user,
      notification: NotificationData(
        id: notification.notifierId,
        title: notification.title,
        body: notification.body,
        notificationType: notification.type,
        notifierId: notification.notifierId,
      ),
    );

    if (navigationData.isNavigationNeeded) {
      await navigator.handleDeepLink(
        type: notification.type,
        notifierId: notification.notifierId,
        data: navigationData.data,
        isAppLaunch: mode == NotificationMode.onLaunch,
      );
    }
  }

  Future<void> _processNavigation(
    NotificationMessage notification,
    NotificationMode mode,
  ) async {
    final title = notification.title;
    final body = notification.body;
    final context = navigatorKey.currentState!.overlay!.context;
    final showViewButton = [
      DeepLinkType.profile,
    ].contains(notification.type);
    if (!context.mounted) return;

    final shouldNavigate = await openAppDialog(
      context,
      title: title,
      content: body,
      positiveButtonText: showViewButton ? S.current.btnView : null,
      negativeButtonText: S.current.btnCancel,
    );
    if (shouldNavigate ?? false) {
      await _handleDeeplink(notification, mode);
    }
  }
}
