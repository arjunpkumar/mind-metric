import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_metric/src/core/app.dart';
import 'package:mind_metric/src/core/exceptions.dart';
import 'package:mind_metric/src/data/auth/auth_service.dart';
import 'package:mind_metric/src/data/auth/user_repository.dart';
import 'package:mind_metric/src/data/core/config_repository.dart';
import 'package:mind_metric/src/data/core/log_services.dart';
import 'package:mind_metric/src/data/core/remote_config/remote_config_repository.dart';
import 'package:mind_metric/src/data/database/auth_settings_dao.dart';
import 'package:mind_metric/src/data/database/auth_token_dao.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';
import 'package:mind_metric/src/data/database/settings_dao.dart';
import 'package:mind_metric/src/presentation/landing/landing_page.dart';
import 'package:mind_metric/src/presentation/widgets/loader_widget.dart';
import 'package:mind_metric/src/utils/auth/auth_util.dart';
import 'package:mind_metric/src/utils/extensions.dart';
import 'package:mind_metric/src/utils/guard.dart';
import 'package:mind_metric/src/utils/secure_storage_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:synchronized/synchronized.dart';

class AuthRepository {
  static AuthRepository? instance;

  final AuthService authServices;
  final AuthUtil authUtil;
  final UserRepository userRepository;
  final ConfigRepository configRepository;
  final RemoteConfigRepository remoteConfigRepository;
  final AuthTokenDao authTokenDao;
  final SettingsDao settingsDao;
  final AuthSettingsDao authSettingsDao;
  final FlutterSecureStorage storage;
  final Logger logger;

  static Lock? _lock;
  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  AuthRepository({
    required this.authServices,
    required this.storage,
    required this.authUtil,
    required this.authTokenDao,
    required this.authSettingsDao,
    required this.settingsDao,
    required this.userRepository,
    required this.configRepository,
    required this.remoteConfigRepository,
    required this.logger,
  }) {
    _lock ??= Lock();
  }

  static String _createCodeVerifier() {
    return List.generate(
      128,
      (i) => _charset[Random.secure().nextInt(_charset.length)],
    ).join();
  }

  Future<User?> signIn(String codeVerifier) async {
    await _checkRemoteConfig();

    final credentials = !kIsWeb && Platform.isWindows
        ? await authServices.signInWindows(codeVerifier: codeVerifier)
        : await authServices.signIn(codeVerifier: codeVerifier);
    return saveCredentials(credentials);
  }

  Future<void> loginWithDio({
    required String email,
    required String password,
  }) async {
    await authServices.loginWithDio(email: email, password: password);
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (kBypassLoginNetwork) {
      return;
    }
    if (Random().nextBool()) {
      return;
    }
    throw Exception('Invalid credentials');
  }

  Future<void> _checkRemoteConfig() async {
    if (!configRepository.isInitialFetchCompleted()) {
      await Guard.runAsync(() async {
        await configRepository.syncConfig();
      });
      if (!configRepository.isInitialFetchCompleted()) {
        if (!(await settingsDao.isInitialFetchCompleted()) ||
            (await remoteConfigRepository.getRemoteConfig()).isEmpty) {
          await remoteConfigRepository.fetchAndUpdateRemoteConfigList();
        }
      }
    }
  }

  Future<String> getCodeVerifier() async {
    await authTokenDao.deleteTokens();

    await _checkRemoteConfig();

    String? codeVerifier;

    if (kIsWeb) {
      codeVerifier = await authSettingsDao.getCodeVerifier();
    } else {
      codeVerifier = await storage.checkAndRead(SecureStorageKey.codeVerifier);
    }

    codeVerifier ??= _createCodeVerifier();
    await _saveCodeVerifier(codeVerifier);
    return codeVerifier;
  }

  Future<User?> saveCredentials(oauth2.Credentials? credentials) async {
    if (credentials != null) {
      logger.log(LogEvents.loggedIn, null);
      await _saveCredentials(credentials);
      return _updateUser(_generateAuthTokenFromCredential(credentials));
    } else {
      logger.log(LogEvents.logInFailed, null);
      return null;
    }
  }

  Future<void> _refreshAccessToken() async {
    if (!await storage.containsKey(key: SecureStorageKey.oAuthCredentials)) {
      return;
    }
    final savedCredentials = oauth2.Credentials.fromJson(
      (kIsWeb
          ? await authSettingsDao.getOAuthCredential()
          : await storage.read(key: SecureStorageKey.oAuthCredentials))!,
    );

    final credentials = await authServices.refreshAccessToken(savedCredentials);
    if (credentials != null) {
      await _saveCredentials(credentials);
      await _updateUser(_generateAuthTokenFromCredential(credentials));
    }
  }

  AuthToken _generateAuthTokenFromCredential(oauth2.Credentials credential) {
    final authToken = AuthToken(
      accessToken: credential.accessToken,
      idToken: credential.idToken!,
      refreshToken: credential.refreshToken,
    );
    return authToken;
  }

  Future<User> _updateUser(AuthToken authToken) async {
    final user = await userRepository.getUser(authToken);
    logger.log(LogEvents.userFetchFromIDS, null);
    try {
      await authTokenDao.deleteTokens();
      await userRepository.deleteUsers();
      await userRepository.saveUser(user);
      await authTokenDao.saveAuthToken(authToken);
      logger.log(LogEvents.logInDBUpdate, null);
    } catch (e) {
      debugPrint(e.toString());
      logger.log(LogEvents.logInDBUpdateFailed, null);
      rethrow;
    }

    return user;
  }

  Future<AuthToken?> getActiveToken() {
    return authTokenDao.getActiveSessionToken();
  }

  Future<bool> isSessionActive() async {
    final token = await getActiveToken();
    final user = await userRepository.getCurrentUser();
    return token != null && user != null;
  }

  Future<bool> signOut() async {
    final token = await getActiveToken();
    final codeVerifier = await storage.read(key: SecureStorageKey.codeVerifier);

    if (token != null && codeVerifier != null) {
      try {
        await authServices.signOut(token, codeVerifier);
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    }

    await authUtil.clearData();

    await _saveCredentials(null);

    /*   bool isNewRouteSameAsCurrent = false;
     Navigator.popUntil(navigatorKey.currentContext!, (route) {
      if (route.settings.name == LoginPage.route) {
        isNewRouteSameAsCurrent = true;
        return true;
      }
      return false;
    });*/

/*    if (!isNewRouteSameAsCurrent) {
      await Navigator.pushNamed(navigatorKey.currentContext!, LoginPage.route);
    }*/
    return true;
  }

  Future<void> processAuthError() async {
    await _lock?.synchronized(() async {
      final lastRefresh = await authSettingsDao.getLastTokenRefresh();
      if (lastRefresh == null ||
          DateTime.now().toUtc().difference(lastRefresh).inMinutes >= 4) {
        try {
          await initRefreshAccessToken();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  Future<void> initRefreshAccessToken() async {
    final token = await getActiveToken();
    if (token?.refreshToken != null) {
      try {
        await _refreshAccessToken();
        await authSettingsDao.saveLastTokenRefresh(DateTime.now().toUtc());
      } catch (err) {
        if ((err is PlatformException &&
                (err.code == "token_failed" ||
                    err.code == "401" ||
                    err.code == "400")) ||
            (err is oauth2.AuthorizationException &&
                err.error == "invalid_grant")) {
          await _logoutAndNavigateToLogin();
        }
        throw CustomException(
          "FAILED TO REFRESH TOKEN",
          message: err.toString(),
        );
      }
    } else {
      await _logoutAndNavigateToLogin();
    }
  }

  Future _logoutAndNavigateToLogin() async {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return const PopScope(
          canPop: false,
          child: LoaderWidget(),
        );
      },
    );
    await signOut();
    Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
    await navigatorKey.currentState!.pushNamedAndRemoveUntil(
      LandingPage.route,
      (route) => false,
    );
  }

  Future<void> _saveCodeVerifier(String codeVerifier) async {
    if (kIsWeb) {
      await authSettingsDao.saveCodeVerifier(codeVerifier);
    } else {
      await storage.write(
        key: SecureStorageKey.codeVerifier,
        value: codeVerifier,
      );
    }
  }

  Future<void> _saveCredentials(oauth2.Credentials? credentials) async {
    if (!kIsWeb) {
      await storage.write(
        key: SecureStorageKey.oAuthCredentials,
        value: credentials?.toJson(),
      );
    } else {
      await authSettingsDao.saveOAuthCredential(credentials?.toJson());
    }
  }
}
