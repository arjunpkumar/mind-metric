import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/src/core/exceptions.dart';
import 'package:flutter_base/src/domain/core/config_repository.dart';
import 'package:flutter_base/src/domain/core/proxy/proxy_service.dart';
import 'package:flutter_base/src/utils/extensions.dart';

class RemoteConfigService {
  final ConfigRepository configRepository;
  final AssetBundle assetBundle;
  final ProxyService proxyService;

  RemoteConfigService({
    required this.configRepository,
    required this.assetBundle,
    required this.proxyService,
  });

  Future<Map<String, dynamic>> fetchRemoteConfigList() async {
    try {
      final firebaseApp = Firebase.app();

      final url = configRepository.restRemoteConfigProviderUrl;
      final response = await proxyService.performProxyCall(
        request: ProxyRequestModel(
          method: ProxyRequestMethod.post,
          url: url,
          data: {
            'project_id': firebaseApp.options.projectId,
          },
        ),
      );

      return toGenericMap(jsonDecode(response.toString()));
    } catch (e) {
      throw CustomException(
        "FETCHING REMOTE CONFIG VIA API FAILED",
        message: e.toString(),
      );
    }
  }
}
