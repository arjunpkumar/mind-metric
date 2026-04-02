import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mind_metric/src/data/fcm/device_token_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceTokenRepository {
  final FirebaseMessaging messagingService;
  final DeviceTokenService tokenServices;
  final FlutterSecureStorage flutterSecureStorage;

  DeviceTokenRepository({
    required this.messagingService,
    required this.tokenServices,
    required this.flutterSecureStorage,
  });

  Future<void> registerToken({
    required String userID,
  }) async {
    /*final token = await messagingService.getToken();
    if (token != null) {
      try {
        await tokenServices.registerToken(
          cdcNumber: cdcNumber,
          token: token,
        );
        await flutterSecureStorage.write(
          key: SecureStorageKey.deviceTokenRegister,
          value: token,
        );
      } catch (exception) {
        debugPrint(exception.toString());
      }
    }*/
  }

  Future<void> deRegisterToken() async {
    /* final token = await messagingService.getToken();
    if (token != null) {
      await tokenServices.deRegisterToken(token: token);
      await messagingService.deleteToken();
    }*/
  }
}
