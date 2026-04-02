import 'package:flutter/foundation.dart';
import 'package:mind_metric/src/data/auth/user_repository.dart';
import 'package:mind_metric/src/data/core/log_services.dart';
import 'package:mind_metric/src/data/fcm/device_token_repository.dart';
import 'package:mind_metric/src/utils/extensions.dart';

class DeviceTokenHelper {
  final DeviceTokenRepository deviceTokenRepository;
  final UserRepository userRepository;

  DeviceTokenHelper({
    required this.deviceTokenRepository,
    required this.userRepository,
  });

  Future<void> registerToken() async {
    final user = await userRepository.getActiveUser();
    try {
      final isSimulator = await isDeviceIOSSimulator();
      if (!isSimulator) {
        await deviceTokenRepository.registerToken(userID: user.id);
        Logger().log(LogEvents.deviceRegistration, null);
      }
    } catch (err) {
      debugPrint(err.toString());
      Logger().log(LogEvents.deviceRegistrationFailed, null);
    }
  }
}
