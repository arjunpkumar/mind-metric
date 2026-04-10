import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:mind_metric/config.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/core/app.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';
import 'package:mind_metric/src/presentation/web_view/web_view_page.dart';
import 'package:mind_metric/src/utils/string_utils.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final List<String> _scopes = [
    'user.read',
    'openid',
    'profile',
    'email',
    'offline_access',
  ];

  Future<oauth2.Credentials?> signIn({required String codeVerifier}) {
    final grant = _getAuthorisationCodeGrant(codeVerifier);

    final Uri authorizationUrl = _getAuthorizationUrl(grant);

    return _openAuthorizationServerLogin(
      S.current.titleLogin,
      authorizationUrl,
      codeVerifier,
      successUrl: Config.appFlavor.authRedirectUri,
    );
  }

  Future<oauth2.Credentials?> signInWindows({
    required String codeVerifier,
  }) async {
    final redirectServer = await HttpServer.bind('localhost', 5000);
    final grant = _getAuthorisationCodeGrant(codeVerifier);
    final Uri authorizationUrl = _getAuthorizationUrl(grant);
    await _openAuthorizationServerLoginForWindows(authorizationUrl);
    final result = await _listenLoginServerForWindows(redirectServer);

    if (StringUtils.isNotNullAndEmpty(result.toString())) {
      return handleOAuthRedirectWeb(Uri.parse(result.toString()), codeVerifier);
    }
    return null;
  }

  Uri _getAuthorizationUrl(oauth2.AuthorizationCodeGrant grant) {
    final url = Uri.parse(
      kIsWeb
          ? '${Uri.base.origin}/auth_redirect.html'
          : Platform.isWindows
              ? 'http://localhost:5000/auth_redirect.html'
              : Config.appFlavor.authRedirectUri,
    );
    final authorizationUrl = grant.getAuthorizationUrl(
      url,
      scopes: _scopes,
    );
    return authorizationUrl;
  }

  oauth2.AuthorizationCodeGrant _getAuthorisationCodeGrant(
    String codeVerifier, {
    String? authUrl,
    String? authTokenUrl,
  }) {
    final grant = oauth2.AuthorizationCodeGrant(
      Config.appFlavor.clientID,
      Uri.parse(authUrl ?? APIEndpoints.authUrl),
      Uri.parse(authTokenUrl ?? APIEndpoints.authTokenUrl),
      secret: Config.appFlavor.clientSecret,
      httpClient: http.Client(),
      codeVerifier: codeVerifier,
      basicAuth: !kIsWeb,
    );
    return grant;
  }

  // Launch the URL in the browser using url_launcher
  Future<void> _openAuthorizationServerLoginForWindows(
    Uri authorizationUrl,
  ) async {
    if (await canLaunchUrl(authorizationUrl)) {
      await launchUrl(authorizationUrl);
    } else {
      throw Exception('Could not launch $authorizationUrl');
    }
  }

  Future<Uri> _listenLoginServerForWindows(HttpServer redirectServer) async {
    final request = await redirectServer.first;
    /*await WindowToFront
        .activate();*/ // Using window_to_front package to bring the window to the front after successful login.
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Authenticated! You can close this tab.');
    await request.response.close();
    await redirectServer.close();
    return request.uri;
  }

  Future<oauth2.Credentials?> _openAuthorizationServerLogin(
    String title,
    Uri authorizationUrl,
    String codeVerifier, {
    bool isAuthTokenNeeded = true,
    String? successUrl,
    String? failureUrl,
    String? alternateSuccessUrl,
  }) async {
    final result = await navigatorKey.currentState?.pushNamed(
      WebViewPage.route,
      arguments: WebViewArgument(
        title: title,
        url: authorizationUrl.toString(),
        successUrl: successUrl,
        failureUrl: failureUrl,
        alternateSuccessUrlList:
            <String?>[alternateSuccessUrl].nonNulls.toList(),
        isBackConfirmationRequired: true,
      ),
    );

    if (isAuthTokenNeeded && result != null) {
      return handleOAuthRedirectWeb(Uri.parse(result.toString()), codeVerifier);
    } else if (!isAuthTokenNeeded && result == null) {
      throw UserCancelledException();
    }
    return null;
  }

  Future<oauth2.Credentials> handleOAuthRedirectWeb(
    Uri redirectUri,
    String codeVerifier,
  ) async {
    final oauth2.AuthorizationCodeGrant grant =
        _getAuthorisationCodeGrant(codeVerifier);
    _getAuthorizationUrl(grant);
    try {
      final client =
          await grant.handleAuthorizationResponse(redirectUri.queryParameters);
      return client.credentials;
    } catch (e) {
      rethrow;
    }
  }

  Future<oauth2.Credentials> refreshAccessToken(
    oauth2.Credentials credentials,
  ) async {
    var client = oauth2.Client(
      credentials,
      identifier: Config.appFlavor.clientID,
      secret: Config.appFlavor.clientSecret,
    );
    client = await client.refreshCredentials(_scopes);
    return client.credentials;
  }

  Future<void> signOut(AuthToken token, String codeVerifier) async {
    final url = '${APIEndpoints.logoutUrl}?id_token_hint=${token.idToken}'
        '&post_logout_redirect_uri=${Config.appFlavor.authRedirectUri}';
    final grant = _getAuthorisationCodeGrant(
      codeVerifier,
      authUrl: url,
      authTokenUrl: url,
    );

    final Uri authorizationUrl = _getAuthorizationUrl(grant);

    await _openAuthorizationServerLogin(
      S.current.titleLogout,
      authorizationUrl,
      codeVerifier,
      failureUrl: APIEndpoints.loginUrl,
      successUrl: Config.appFlavor
          .authRedirectUri, // successUrl: Config.appFlavor.logoutRedirectUri,
      alternateSuccessUrl: APIEndpoints.logoutSessionUrl,
      isAuthTokenNeeded: false,
    );
  }

  Future<Map<String, dynamic>> loginWithDio({
    required String email,
    required String password,
  }) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://172.27.13.182:5062/api/Auth/Login',
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Login failed');
      }
      
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['succeeded'] == true) {
        return responseData['data'] as Map<String, dynamic>;
      } else {
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed');
    }
  }
}

class UserCancelledException implements Exception {}
