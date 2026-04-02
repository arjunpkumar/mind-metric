// native.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mind_metric/src/application/core/bloc_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

LazyDatabase constructDb() {
  return LazyDatabase(() async {
    final fileUtil = provideFileUtil();
    final path = await fileUtil.getApplicationPath();
    final file = File(p.join(path, 'db.sqlite'));

    /*Code for Sharing and copying db file*/
/*  await Share.shareXFiles([XFile(file.path)]);

    final externalPath = await fileUtil.getDownloadPath();
    final externalFile = File(p.join(externalPath, 'Ahoy', 'db.sqlite'));
    await fileUtil.copyFile(file, externalFile.path);*/

    // Also work around limitations on old Android versions
/*    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }*/

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cacheDB = await fileUtil.getApplicationTempPath();
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cacheDB;

    return NativeDatabase.createInBackground(
      file,
      setup: (database) {
        // 1. Enable WAL mode
        database.execute('PRAGMA journal_mode=WAL;');
        // 2. Increase the timeout to give busy operations time to finish
        database.execute('PRAGMA busy_timeout=5000;');
      },
    );

    // return NativeDatabase(file);
  });
}
