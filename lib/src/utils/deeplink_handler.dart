// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_base/src/utils/deeplink_navigator.dart';

class DeeplinkHandler {
  final DeeplinkNavigator navigator;

  DeeplinkHandler({required this.navigator});

  Future<void> setup() async {
    /*final dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
    await onDynamicLinkDataReceived(
      dynamicLink: dynamicLink,
      isAppLaunch: true,
    );

    FirebaseDynamicLinks.instance.onLink.listen(
      (link) async {
        await onDynamicLinkDataReceived(
          dynamicLink: dynamicLink,
          isAppLaunch: false,
        );
      },
    );*/
  }

  /*Future<void> onDynamicLinkDataReceived({
    required PendingDynamicLinkData? dynamicLink,
    required bool isAppLaunch,
  }) async {
    final Uri? deepLink = dynamicLink?.link;
    if (deepLink == null) {
      return;
    }
    final type = deepLink.queryParameters['dl_type'];
    if (type == null) {
      return;
    }
    await navigator.handleDeepLink(
      type: type,
      isAppLaunch: isAppLaunch,
    );
  }*/
}
