import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/src/application/sync/job_connectivity.dart';
import 'package:flutter_base/src/application/sync/job_manager.dart';
import 'package:flutter_base/src/application/sync/job_timer.dart';
import 'package:flutter_base/src/application/sync/syncable_provider.dart';
import 'package:flutter_base/src/data/auth/auth_repository.dart';
import 'package:flutter_base/src/data/auth/auth_service.dart';
import 'package:flutter_base/src/data/auth/user_repository.dart';
import 'package:flutter_base/src/data/auth/user_service.dart';
import 'package:flutter_base/src/data/core/config_repository.dart';
import 'package:flutter_base/src/data/core/log_services.dart';
import 'package:flutter_base/src/data/core/proxy/proxy_service.dart';
import 'package:flutter_base/src/data/core/remote_config/remote_config_repository.dart';
import 'package:flutter_base/src/data/core/remote_config/remote_config_service.dart';
import 'package:flutter_base/src/data/core/sync/job_repository.dart';
import 'package:flutter_base/src/data/database/auth_settings_dao.dart';
import 'package:flutter_base/src/data/database/core/app_database.dart';
import 'package:flutter_base/src/data/database/remote_config_dao.dart';
import 'package:flutter_base/src/data/database/settings_dao.dart';
import 'package:flutter_base/src/data/fcm/device_token_repository.dart';
import 'package:flutter_base/src/data/fcm/device_token_service.dart';
import 'package:flutter_base/src/utils/auth/auth_util.dart';
import 'package:flutter_base/src/utils/biometric_local_auth_utils.dart';
import 'package:flutter_base/src/utils/file_downloader.dart';
import 'package:flutter_base/src/utils/network_validator.dart';
import 'package:flutter_base/src/utils/sync/job_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

ConfigRepository provideConfigRepository() {
  return ConfigRepository.instance();
}

RemoteConfigRepository provideRemoteConfigRepository() {
  return RemoteConfigRepository.instance ??= RemoteConfigRepository(
    dao: RemoteConfigDao(),
    settingsDao: SettingsDao(),
    service: RemoteConfigService(
      configRepository: provideConfigRepository(),
      assetBundle: rootBundle,
      proxyService: provideProxyService(),
    ),
  );
}

ProxyService provideProxyService() {
  return ProxyService(
    configRepository: provideConfigRepository(),
  );
}

FlutterSecureStorage provideFlutterSecureStorage() {
  return const FlutterSecureStorage();
}


AuthUtil provideAuthUtil() {
  return AuthUtil(
    appDatabase: provideAppDatabase(),
    authSettingsDao: AuthSettingsDao(),
    jobTimer: provideJobTimer(),
    // networkUsageRepository: provideNetworkUsagesRepository(),
    settingsDao: SettingsDao(),
    storage: provideFlutterSecureStorage(),
  );
}

Logger provideLogger() {
  return Logger();
}


NetworkValidator provideNetworkValidator() {
  return NetworkValidator.instance ??= NetworkValidator(
    connectivity: Connectivity(),
  );
}

AppDatabase provideAppDatabase() {
  return AppDatabase.instance();
}

UserService provideUserService() {
  return UserService(
    configRepository: provideConfigRepository(),
  );
}


JobConnectivity provideJobConnectivity() {
  return JobConnectivity(
    jobTimer: provideJobTimer(),
    networkValidator: provideNetworkValidator(),
    jobManager: provideJobManager(),
    authRepository: provideAuthRepository(),
    connectivity: Connectivity(),
  );
}

JobTimer provideJobTimer() {
  return JobTimer.instance ??
      JobTimer.init(
        jobManager: provideJobManager(),
      );
}

JobManager provideJobManager() {
  return JobManager.instance ??= JobManager.init(
    userRepository: provideUserRepository(),
    networkValidator: provideNetworkValidator(),
    jobRepository: provideJobRepository(),
    syncableProvider: SyncableProvider(),
  );
}

JobRepository provideJobRepository() {
  return JobRepository.instance ??=
      JobRepository.init(jobDao: provideAppDatabase().jobDao);
}

JobUtils provideJobUtils() {
  return JobUtils.instance ??= JobUtils(
    jobRepository: provideJobRepository(),
    jobManager: provideJobManager(),
  );
}

AuthRepository provideAuthRepository() {
  return AuthRepository.instance ??= AuthRepository(
    authUtil: provideAuthUtil(),
    authServices: AuthService(),
    authTokenDao: provideAppDatabase().authTokenDao,
    authSettingsDao: AuthSettingsDao(),
    settingsDao: SettingsDao(),
    remoteConfigRepository: provideRemoteConfigRepository(),
    userRepository: provideUserRepository(),
    storage: provideFlutterSecureStorage(),
    logger: provideLogger(),
    configRepository: provideConfigRepository(),
  );
}

UserRepository provideUserRepository() {
  return UserRepository.instance ??= UserRepository(
    userDao: provideAppDatabase().userDao,
    networkProvider: provideUserService(),
    userMapper: UserMapper(),
  );
}

DeviceTokenRepository provideDeviceTokenRepository() {
  return DeviceTokenRepository(
    messagingService: provideFireBaseMessaging(),
    tokenServices: provideDeviceTokenServices(),
    flutterSecureStorage: provideFlutterSecureStorage(),
  );
}

FirebaseMessaging provideFireBaseMessaging() {
  return FirebaseMessaging.instance;
}

DeviceTokenService provideDeviceTokenServices() {
  return DeviceTokenService();
}

FileDownloader provideFileDownloader() {
  return FileDownloader(
    authRepository: provideAuthRepository(),
  );
}

BiometricLocalAuthUtils provideBiometricLocalAuthUtils() {
  return BiometricLocalAuthUtils(
    localAuthentication: provideLocalAuthentication(),
    deviceInfoPlugin: DeviceInfoPlugin(),
  );
}

LocalAuthentication provideLocalAuthentication() {
  return LocalAuthentication();
}
