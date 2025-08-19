import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/config.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/src/core/app_constants.dart';
import 'package:flutter_base/src/data/app_update/in_app_update.dart';
import 'package:flutter_base/src/data/app_update/store_version.dart';
import 'package:flutter_base/src/data/core/config_repository.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum UpdateMode { flexible, immediate, none }

class UpdateInfo {
  final int currentVersion;
  final int updateVersion;
  final UpdateMode mode;

  UpdateInfo({
    required this.currentVersion,
    required this.updateVersion,
    required this.mode,
  });
}

class AppVersionWidget extends StatefulWidget {
  final Widget child;
  final ConfigRepository configRepository;

  const AppVersionWidget({
    super.key,
    required this.configRepository,
    required this.child,
  });

  @override
  State<AppVersionWidget> createState() => _AppVersionWidgetState();
}

class _AppVersionWidgetState extends State<AppVersionWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => checkForUpdatesIfNeeded());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<bool> isNotificationsEnabled() {
    return Permission.notification.isGranted;
  }

  Future<bool> shouldCheckForUpdates() async {
    if (Config.appFlavor is! Development && Config.appMode == AppMode.release) {
      return true;
    }
    // final notificationsEnabled = await isNotificationsEnabled();
    // return !notificationsEnabled;
    return false;
  }

  Future<void> checkForUpdatesIfNeeded() async {
    final shouldCheck = await shouldCheckForUpdates();
    if (shouldCheck) {
      widget.configRepository.initConfig();

      final info = await getVersionUpdateInfo();
      await Future.delayed(const Duration(seconds: 1));
      await takeActionForUpdateInfo(info);
    }
  }

  Future<UpdateInfo> getVersionUpdateInfo() async {
    final packageInfo = Config.packageInfo;
    final currentVersion = int.parse(packageInfo?.buildNumber ?? "0");
    final latestStableVersion = getLatestStableVersion() ?? 0;
    final latestVersion = getLatestVersion() ?? 0;
    UpdateMode updateMode;

    bool isStoreUpdateAvailable = false;

    try {
      if (Platform.isAndroid && Config.appMode == AppMode.release) {
        final info = await InAppUpdate.checkForUpdate();
        // info.updateAvailability will give the result in integer
        isStoreUpdateAvailable =
            info.updateAvailability == UpdateAvailability.updateAvailable;
      } else if (Platform.isIOS) {
        final updateStatus = await StoreVersion(iOSId: packageInfo?.packageName)
            .getVersionStatus();
        isStoreUpdateAvailable = updateStatus?.canUpdate ?? false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    if (latestStableVersion > currentVersion) {
      updateMode = UpdateMode.immediate;
    } else if (currentVersion < latestVersion || isStoreUpdateAvailable) {
      updateMode = UpdateMode.flexible;
    } else {
      updateMode = UpdateMode.none;
    }

    return UpdateInfo(
      currentVersion: currentVersion,
      updateVersion: latestVersion,
      mode: updateMode,
    );
  }

  int? getLatestStableVersion() {
    try {
      int version;
      if (Platform.isIOS) {
        version = Config.appFlavor.iOSMinVersionCode;
      } else if (Platform.isAndroid) {
        version = Config.appFlavor.androidMinVersionCode;
      } else {
        throw UnimplementedError();
      }
      return version;
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
  }

  int? getLatestVersion() {
    try {
      int version;
      if (Platform.isIOS) {
        version = Config.appFlavor.iOSLatestVersionCode;
      } else if (Platform.isAndroid) {
        version = Config.appFlavor.androidLatestVersionCode;
      } else {
        throw UnimplementedError();
      }
      return version;
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
  }

  Future<void> takeActionForUpdateInfo(UpdateInfo info) async {
    switch (info.mode) {
      case UpdateMode.none:
        break;
      case UpdateMode.immediate:
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                getImmediateUpdateTitle(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                getImmediateUpdateMessage(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => openStore(),
                  child: Text(S.current.btnUpdate.toUpperCase()),
                ),
              ],
            );
          },
        );
      case UpdateMode.flexible:
        hasIgnoredPreviously(info.updateVersion).then((hasIgnored) {
          if (hasIgnored && !mounted) {
            return null;
          }
          return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  getFlexibleUpdateTitle(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                content: Text(
                  getFlexibleUpdateMessage(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      ignoreVersion(info.updateVersion).then((value) {
                        if (context.mounted) Navigator.pop(context);
                      });
                    },
                    child: Text(S.current.btnLater.toUpperCase()),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await openStore();
                    },
                    child: Text(S.current.btnUpdate.toUpperCase()),
                  ),
                ],
              );
            },
          );
        });
    }
  }

  Future<void> openStore() async {
    String url = "";
    if (Platform.isAndroid) {
      url = androidPlayStoreUrl;
    } else if (Platform.isIOS) {
      url = iosAppStoreUrl;
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  static const String boxName = 'ignored_app_versions';

  Future<bool> hasIgnoredPreviously(int version) async {
    final box = await Hive.openBox<int>(boxName);
    return box.values.contains(version);
  }

  Future<void> ignoreVersion(int version) async {
    final box = await Hive.openBox<int>(boxName);
    await box.add(version);
  }

  String getImmediateUpdateTitle() {
    try {
      return widget.configRepository.immediateUpdateTitle;
    } catch (err) {
      return S.current.titleImmediateUpdate;
    }
  }

  String getImmediateUpdateMessage() {
    try {
      return widget.configRepository.immediateUpdateMessage;
    } catch (err) {
      return S.current.messageImmediateUpdate;
    }
  }

  String getFlexibleUpdateTitle() {
    try {
      return widget.configRepository.flexibleUpdateTitle;
    } catch (err) {
      debugPrint(err.toString());
      return S.current.titleFlexibleUpdate;
    }
  }

  String getFlexibleUpdateMessage() {
    try {
      return widget.configRepository.flexibleUpdateMessage;
    } catch (err) {
      debugPrint(err.toString());
      return S.current.messageFlexibleUpdate;
    }
  }
}
