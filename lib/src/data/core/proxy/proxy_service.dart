import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/core/exceptions.dart';
import 'package:mind_metric/src/data/core/config_repository.dart';

/// Created by Jemsheer K D on 18 July, 2024.
/// File Name : proxy_service
/// Project : FlutterBase

class ProxyService {
  final ConfigRepository configRepository;

  ProxyService({
    required this.configRepository,
  });

  Future<dynamic> performProxyCall({
    required ProxyRequestModel request,
  }) async {
    try {
      final response = await NetworkClient.dioInstance.post(
        configRepository.synergyProxy,
        data: request.toMap(),
      );
      return response.data;
    } catch (e) {
      throw CustomException(
        "PROXY CALL FAILED : ${request.url}",
        message: e.toString(),
      );
    }
  }
}

class ProxyRequestModel {
  String method;
  String url;
  Map<String, dynamic>? headers;
  Map<String, dynamic>? data;

  ProxyRequestModel({
    this.method = ProxyRequestMethod.get,
    required this.url,
    this.headers,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'url': url,
      'headers': headers,
      'body': data,
    };
  }
}

class ProxyRequestMethod {
  ProxyRequestMethod._();

  static const get = "GET";
  static const post = "POST";
  static const put = "PUT";
  static const delete = "DELETE";
}
