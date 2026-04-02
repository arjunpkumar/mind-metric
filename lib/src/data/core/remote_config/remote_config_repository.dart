import 'package:mind_metric/src/data/core/config_repository.dart';
import 'package:mind_metric/src/data/core/remote_config/remote_config_service.dart';
import 'package:mind_metric/src/data/database/remote_config_dao.dart';
import 'package:mind_metric/src/data/database/settings_dao.dart';
import 'package:mind_metric/src/utils/guard.dart';

/// Created by Jemsheer K D on 25 September, 2023.
/// File Name : remote_config_repository
/// Project : FlutterBase

class RemoteConfigRepository {
  static RemoteConfigRepository? instance;

  final RemoteConfigService service;
  final RemoteConfigDao dao;
  final SettingsDao settingsDao;

  RemoteConfigRepository({
    required this.service,
    required this.dao,
    required this.settingsDao,
  });

  Future fetchAndUpdateRemoteConfigList() async {
    await Guard.runAsync(() async {
      final result = await service.fetchRemoteConfigList();
      if (result.isNotEmpty) {
        await dao.saveRemoteConfig(result);
      }
    });

    await Guard.runAsync(() async {
      final data = await dao.getRemoteConfig();
      await updateDefaultConfig(data);
      await settingsDao.setInitialFetchCompleted(true);
    });
  }

  Future<Map<String, dynamic>> getRemoteConfig() {
    return dao.getRemoteConfig();
  }
}
