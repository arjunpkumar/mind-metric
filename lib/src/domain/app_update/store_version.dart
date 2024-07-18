import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/src/utils/extensions.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

/// Information about the app's current version, and the most recent version
/// available in the Apple App Store or Google Play Store.
class VersionStatus {
  /// The current version of the app.
  final String? localVersion;

  /// The most recent version of the app in the store.
  final String? storeVersion;

  /// A link to the app store page where the app can be updated.
  final String? appStoreLink;

  /// The release notes for the store version of the app.
  final String? releaseNotes;

  /// True if the there is a more recent version of the app in the store.
  // bool get canUpdate => localVersion.compareTo(storeVersion).isNegative;
  // version strings can be of the form xx.yy.zz (build)
  bool get canUpdate {
    // assume version strings can be of the form xx.yy.zz
    // this implementation correctly compares local 1.10.1 to store 1.9.4
    try {
      final localFields = localVersion!.split('.');
      final storeFields = storeVersion!.split('.');
      final StringBuffer localPad = StringBuffer();
      final StringBuffer storePad = StringBuffer();
      for (int i = 0; i < storeFields.length; i++) {
        /*localPad = localPad + localFields[i].padLeft(3, '0');*/
        localPad.write(localFields[i].padLeft(3, '0'));
        /*storePad = storePad + storeFields[i].padLeft(3, '0');*/
        storePad.write(storeFields[i].padLeft(3, '0'));
      }
      return localPad.toString().compareTo(storePad.toString()) < 0;
    } catch (e) {
      return localVersion
          .toString()
          .compareTo(storeVersion.toString())
          .isNegative;
    }
  }

  VersionStatus._({
    required this.localVersion,
    required this.storeVersion,
    required this.appStoreLink,
    required this.releaseNotes,
  });
}

class StoreVersion {
  /// An optional value that can override the default packageName when
  /// attempting to reach the Apple App Store. This is useful if your app has
  /// a different package name in the App Store.
  final String? iOSId;

  /// An optional value that can override the default packageName when
  /// attempting to reach the Google Play Store. This is useful if your app has
  /// a different package name in the Play Store.
  final String? androidId;

  /// Only affects iOS App Store lookup: The two-letter country code for the store you want to search.
  /// Provide a value here if your app is only available outside the US.
  /// For example: US. The default is US.
  /// See http://en.wikipedia.org/wiki/ ISO_3166-1_alpha-2 for a list of ISO Country Codes.
  final String? iOSAppStoreCountry;

  StoreVersion({
    this.androidId,
    this.iOSId,
    this.iOSAppStoreCountry,
  });

  /// This checks the version status and returns the information. This is useful
  /// if you want to display a custom alert, or use the information in a different
  /// way.
  Future<VersionStatus?> getVersionStatus() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      return _getIOSStoreVersion(packageInfo);
    } else {
      debugPrint(
        'The target platform "${Platform.operatingSystem}" is not yet supported by this package.',
      );
      throw MissingPluginException();
    }
  }

  /// iOS info is fetched by using the iTunes lookup API, which returns a
  /// JSON document.
  Future<VersionStatus?> _getIOSStoreVersion(PackageInfo packageInfo) async {
    final id = iOSId ?? packageInfo.packageName;
    final parameters = {"bundleId": id};
    if (iOSAppStoreCountry != null) {
      parameters.addAll({"country": iOSAppStoreCountry!});
    }
    final uri = Uri.https("itunes.apple.com", "/lookup", parameters);
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint("Can't find an app in the App Store with the id: $id");
      return null;
    }
    final jsonObj = toGenericMap(json.decode(response.body));

    final data = toGenericMapList(jsonObj['results']).first;
    return VersionStatus._(
      localVersion: packageInfo.version,
      storeVersion: data['version'] as String,
      appStoreLink: data['trackViewUrl'] as String,
      releaseNotes: data['releaseNotes'] as String,
    );
  }
}
