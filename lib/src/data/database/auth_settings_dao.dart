import 'package:mind_metric/src/data/database/base_hive_dao.dart';
import 'package:hive/hive.dart';

class AuthSettingsDao extends BaseHiveDao {
  static const kLastTokenRefresh = 'last_token_refresh';
  static const kCodeVerifier = 'code_verifier';
  static const kOAuthCredential = 'oauth_credential';

  Future<Box> getBox() {
    return Hive.openBox('auth_settings');
  }

  Future<void> saveLastTokenRefresh(DateTime data) async {
    final box = await getBox();
    await box.put(kLastTokenRefresh, data);
  }

  Future<DateTime?> getLastTokenRefresh() async {
    final box = await getBox();
    final value = box.get(kLastTokenRefresh);
    if (value == null) return null;
    return value as DateTime;
  }

  Future<void> saveCodeVerifier(String data) async {
    final box = await getBox();
    await box.put(kCodeVerifier, data);
  }

  Future<String?> getCodeVerifier() async {
    final box = await getBox();
    final value = box.get(kCodeVerifier);
    if (value == null) return null;
    return value as String;
  }

  Future<void> saveOAuthCredential(String? data) async {
    final box = await getBox();
    await box.put(kOAuthCredential, data);
  }

  Future<String?> getOAuthCredential() async {
    final box = await getBox();
    final value = box.get(kOAuthCredential);
    if (value == null) return null;
    return value as String;
  }

  @override
  Future<void> clear() async {
    final box = await getBox();
    await box.clear();
  }
}
