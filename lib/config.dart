import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mind_metric/src/data/core/config_repository.dart';
import 'package:mind_metric/src/utils/network_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class Flavor {
  String get name;

  int get iOSMinVersionCode;

  int get iOSLatestVersionCode;

  int get androidMinVersionCode;

  int get androidLatestVersionCode;

  String get restApiVersion;

  String get restBaseUrl;

  String get identityServerBaseUrl;

  String get authRedirectUri;

  String get tenantID;

  String get clientID;

  String get clientSecret;
}

class Development extends Flavor {
  @override
  String get name => "DEVELOPMENT";

  @override
  String get restBaseUrl =>
      ConfigRepository.instance().restBaseUrlDev + restApiVersion;

  @override
  String get identityServerBaseUrl =>
      ConfigRepository.instance().identityServerUrlDev;

  @override
  String get authRedirectUri => ConfigRepository.instance().authRedirectUriDev;

  @override
  int get androidMinVersionCode =>
      ConfigRepository.instance().androidMinVersionCodeDev;

  @override
  int get androidLatestVersionCode =>
      ConfigRepository.instance().androidLatestVersionCodeDev;

  @override
  int get iOSMinVersionCode => ConfigRepository.instance().iOSMinVersionCodeDev;

  @override
  int get iOSLatestVersionCode =>
      ConfigRepository.instance().iOSLatestVersionCodeDev;

  @override
  String get restApiVersion => "";

  @override
  String get clientID => ConfigRepository.instance().clientIDDev;

  @override
  String get clientSecret => ConfigRepository.instance().clientSecretDev;

  @override
  String get tenantID => ConfigRepository.instance().tenantIDDev;
}

class QA extends Flavor {
  @override
  String get name => "QA";

  @override
  String get restBaseUrl =>
      ConfigRepository.instance().restBaseUrlQA + restApiVersion;

  @override
  String get identityServerBaseUrl =>
      ConfigRepository.instance().identityServerUrlQA;

  @override
  String get authRedirectUri => ConfigRepository.instance().authRedirectUriDev;

  @override
  int get androidMinVersionCode =>
      ConfigRepository.instance().androidMinVersionCodeQA;

  @override
  int get androidLatestVersionCode =>
      ConfigRepository.instance().androidLatestVersionCodeQA;

  @override
  int get iOSMinVersionCode => ConfigRepository.instance().iOSMinVersionCodeQA;

  @override
  int get iOSLatestVersionCode =>
      ConfigRepository.instance().iOSLatestVersionCodeQA;

  @override
  String get restApiVersion => "";

  @override
  String get clientID => ConfigRepository.instance().clientIDQA;

  @override
  String get clientSecret => ConfigRepository.instance().clientSecretQA;

  @override
  String get tenantID => ConfigRepository.instance().tenantIDQA;
}

class Staging extends Flavor {
  @override
  String get name => "STAGING";

  @override
  String get restBaseUrl =>
      ConfigRepository.instance().restBaseUrlStaging + restApiVersion;

  @override
  String get identityServerBaseUrl =>
      ConfigRepository.instance().identityServerUrlStaging;

  @override
  String get authRedirectUri =>
      ConfigRepository.instance().authRedirectUriStaging;

  @override
  int get androidMinVersionCode =>
      ConfigRepository.instance().androidMinVersionCodeStaging;

  @override
  int get androidLatestVersionCode =>
      ConfigRepository.instance().androidLatestVersionCodeStaging;

  @override
  int get iOSMinVersionCode =>
      ConfigRepository.instance().iOSMinVersionCodeStaging;

  @override
  int get iOSLatestVersionCode =>
      ConfigRepository.instance().iOSLatestVersionCodeStaging;

  @override
  String get restApiVersion => "";

  @override
  String get clientID => ConfigRepository.instance().clientIDStaging;

  @override
  String get clientSecret => ConfigRepository.instance().clientSecretStaging;

  @override
  String get tenantID => ConfigRepository.instance().tenantIDStaging;
}

class Production extends Flavor {
  @override
  String get name => "PRODUCTION";

  @override
  String get restBaseUrl =>
      ConfigRepository.instance().restBaseUrlProd + restApiVersion;

  @override
  String get identityServerBaseUrl =>
      ConfigRepository.instance().identityServerUrlProd;

  @override
  String get authRedirectUri => ConfigRepository.instance().authRedirectUriProd;

  @override
  int get androidMinVersionCode =>
      ConfigRepository.instance().androidMinVersionCodeProd;

  @override
  int get androidLatestVersionCode =>
      ConfigRepository.instance().androidLatestVersionCodeProd;

  @override
  int get iOSMinVersionCode =>
      ConfigRepository.instance().iOSMinVersionCodeProd;

  @override
  int get iOSLatestVersionCode =>
      ConfigRepository.instance().iOSLatestVersionCodeProd;

  @override
  String get restApiVersion => "";

  @override
  String get clientID => ConfigRepository.instance().clientIDProd;

  @override
  String get clientSecret => ConfigRepository.instance().clientSecretProd;

  @override
  String get tenantID => ConfigRepository.instance().tenantIDProd;
}

enum AppMode {
  debug,
  release,
  profile,
}

class Config {
  Config._();

  static late Flavor appFlavor;
  static String? _appSource;
  static PackageInfo? packageInfo;
  static IosDeviceInfo? iOSDeviceInfo;
  static AndroidDeviceInfo? androidDeviceInfo;
  static AppMode appMode = _getCurrentMode();

  static String getVersionName() {
    return packageInfo?.version ?? "";
  }

  static String getBuildNumber() {
    return packageInfo?.buildNumber ?? "";
  }

  static String get appSource => _appSource ?? _getAppSource();

  static AppMode _getCurrentMode() {
    AppMode mode;

    bool isDebug = false;
    assert(isDebug = true);

    if (isDebug) {
      mode = AppMode.debug;
    } else if (const bool.fromEnvironment("dart.vm.product")) {
      mode = AppMode.release;
    } else {
      mode = AppMode.profile;
    }

    return mode;
  }

  static String _getAppSource() {
    if (kIsWeb) return AppSource.web;
    if (Platform.isAndroid || Platform.isFuchsia) return AppSource.android;
    if (Platform.isIOS) return AppSource.iOS;
    if (Platform.isMacOS) return AppSource.macOS;
    if (Platform.isWindows) return AppSource.windows;
    if (Platform.isLinux) return AppSource.linux;
    return "";
  }
}
