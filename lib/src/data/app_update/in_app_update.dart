import 'package:flutter/services.dart';
import 'package:mind_metric/src/utils/extensions.dart';

class UpdateAvailability {
  UpdateAvailability._();

  static int get unknown => 0;

  static int get updateNotAvailable => 1;

  static int get updateAvailable => 2;

  static int get developerTriggeredUpdateInProgress => 3;
}

class InAppUpdate {
  static const MethodChannel _channel = MethodChannel('in_app_update');

  /// Has to be called before being able to start any update.
  /// Returns [AppUpdateInfo], which can be used to decide if
  /// [startFlexibleUpdate] or [performImmediateUpdate] should be called.
  static Future<InAppUpdateInfo> checkForUpdate() async {
    final data = await _channel.invokeMethod('checkForUpdate');

    final result = toGenericMap(data);
    return InAppUpdateInfo(
      result['updateAvailability'] as int,
      result['immediateAllowed'] as bool,
      result['flexibleAllowed'] as bool,
      result['availableVersionCode'] as int,
      result['installStatus'] as int,
      result['packageName'] as String,
      result['clientVersionStalenessDays'] as int,
      result['updatePriority'] as int,
    );
  }

  /// Performs an immediate update that is entirely handled by the Play API.
  ///
  /// [checkForUpdate] has to be called first to be able to run this.
  static Future<void> performImmediateUpdate() {
    return _channel.invokeMethod('performImmediateUpdate');
  }

  /// Starts the download of the app update.
  ///
  /// Throws a [PlatformException] if the download fails.
  /// When the returned [Future] is completed without any errors,
  /// [completeFlexibleUpdate] can be called to install the update.
  ///
  /// [checkForUpdate] has to be called first to be able to run this.
  static Future<void> startFlexibleUpdate() {
    return _channel.invokeMethod('startFlexibleUpdate');
  }

  /// Installs the update downloaded via [startFlexibleUpdate].
  /// [startFlexibleUpdate] has to be completed successfully.
  static Future<void> completeFlexibleUpdate() {
    return _channel.invokeMethod('completeFlexibleUpdate');
  }
}

class InAppUpdateInfo {
  final int updateAvailability;
  final bool immediateUpdateAllowed;
  final bool flexibleUpdateAllowed;
  final int availableVersionCode;
  final int installStatus;
  final String packageName;
  final int updatePriority;
  final int clientVersionStalenessDays;

  InAppUpdateInfo(
    this.updateAvailability,
    this.immediateUpdateAllowed,
    this.flexibleUpdateAllowed,
    this.availableVersionCode,
    this.installStatus,
    this.packageName,
    this.clientVersionStalenessDays,
    this.updatePriority,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppUpdateInfo &&
          runtimeType == other.runtimeType &&
          updateAvailability == other.updateAvailability &&
          immediateUpdateAllowed == other.immediateUpdateAllowed &&
          flexibleUpdateAllowed == other.flexibleUpdateAllowed &&
          availableVersionCode == other.availableVersionCode &&
          installStatus == other.installStatus &&
          packageName == other.packageName &&
          clientVersionStalenessDays == other.clientVersionStalenessDays &&
          updatePriority == other.updatePriority;

  @override
  int get hashCode =>
      updateAvailability.hashCode ^
      immediateUpdateAllowed.hashCode ^
      flexibleUpdateAllowed.hashCode ^
      availableVersionCode.hashCode ^
      installStatus.hashCode ^
      packageName.hashCode ^
      clientVersionStalenessDays.hashCode ^
      updatePriority.hashCode;

  @override
  String toString() =>
      'InAppUpdateState{updateAvailability: $updateAvailability, '
      'immediateUpdateAllowed: $immediateUpdateAllowed, '
      'flexibleUpdateAllowed: $flexibleUpdateAllowed, '
      'availableVersionCode: $availableVersionCode, '
      'installStatus: $installStatus, '
      'packageName: $packageName, '
      'clientVersionStalenessDays: $clientVersionStalenessDays, '
      'updatePriority: $updatePriority}';
}
