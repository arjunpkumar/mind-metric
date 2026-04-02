import 'package:mind_metric/src/application/sync/job_timer.dart';
import 'package:mind_metric/src/data/database/auth_settings_dao.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';
import 'package:mind_metric/src/data/database/settings_dao.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : auth_util
/// Project : FlutterBase

class AuthUtil {
  final JobTimer jobTimer;
  final FlutterSecureStorage storage;
  final AppDatabase appDatabase;
  final SettingsDao settingsDao;
  final AuthSettingsDao authSettingsDao;

  AuthUtil({
    required this.jobTimer,
    required this.appDatabase,
    required this.storage,
    required this.settingsDao,
    required this.authSettingsDao,
  });

  Future clearData() async {
    jobTimer.stopTimer();
/*    try {
      await networkUsageRepository.syncPendingLogs();
    } catch (_) {}*/
    Future.wait([
      storage.deleteAll(),
      appDatabase.clearUserRelatedTables(),
      /* appDatabase.lastSyncedTimestampsDao.deleteTimestampsForTables(
        appDatabase.userRelatedTables
            .map((t) => t.actualTableName)
            .toList(growable: false),
      ),*/
      settingsDao.clear(),
      authSettingsDao.clear(),
    ]);
  }
}
