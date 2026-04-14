import 'package:hive/hive.dart';
import 'package:mind_metric/src/data/database/base_hive_dao.dart';
import 'package:mind_metric/src/utils/extensions.dart';

class SettingsDao extends BaseHiveDao {
  static const kUserSecurity = 'user_security';
  static const kInitialFetch = 'initial_fetch';
  /// Persists numeric user id from [Auth/Login] for quiz [POST /api/Question/Submit].
  static const kQuizSubmitUserId = 'quiz_submit_user_id';

  Future<Box> getBox() {
    return Hive.openBox("settings");
  }

  Future<void> setSecurityEnabled(bool value) async {
    final box = await getBox();
    box.put(kUserSecurity, value);
  }

  Future<bool> isSecurityEnabled() async {
    final box = await getBox();
    final value = await box.get(kUserSecurity);
    return toDefaultBool(value, defaultValue: true);
  }

  Future<void> setInitialFetchCompleted(bool value) async {
    final box = await getBox();
    box.put(kInitialFetch, value);
  }

  Future<bool> isInitialFetchCompleted() async {
    final box = await getBox();
    final value = await box.get(kInitialFetch);
    return toDefaultBool(value);
  }

  Future<void> setQuizSubmitUserId(int userId) async {
    final box = await getBox();
    await box.put(kQuizSubmitUserId, userId);
  }

  Future<int?> getQuizSubmitUserId() async {
    final box = await getBox();
    final value = await box.get(kQuizSubmitUserId);
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  @override
  Future<void> clear() async {
    final box = await getBox();
    await box.clear();
  }
}
