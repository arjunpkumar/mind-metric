// native.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_base/src/application/core/bloc_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

LazyDatabase constructDb() {
  return LazyDatabase(() async {
    final fileUtil = provideFileUtil();
    final path = await fileUtil.getApplicationPath();
    final file = File(p.join(path, 'db.sqlite'));

    /*Code for Sharing and copying db file*/
/*  await Share.shareXFiles([XFile(file.path)]);

    final externalPath = await FileUtil.getDownloadPath();
    final externalFile = File(p.join(externalPath, 'Flutter Base', 'db.sqlite'));
    await FileUtil().copyFile(file, externalFile.path);
*/

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cacheDB = await fileUtil.getApplicationTempPath();
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cacheDB;

    return NativeDatabase.createInBackground(file);

    // return NativeDatabase(file);
  });
}
