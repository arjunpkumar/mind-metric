import 'package:drift/drift.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';

part 'auth_token_dao.g.dart';

@DriftAccessor(tables: [AuthTokens])
class AuthTokenDao extends DatabaseAccessor<AppDatabase>
    with _$AuthTokenDaoMixin {
  AuthTokenDao(super.db);

  Future<int> saveAuthToken(AuthToken entry) {
    return into(authTokens).insert(entry);
  }

  Future<void> deleteTokens() {
    return delete(authTokens).go();
  }

  Future<AuthToken?> getActiveSessionToken() async {
    final tokens = await select(authTokens).get();
    if (tokens.isEmpty) {
      return null;
    }
    return tokens.first;
  }
}

class AuthTokens extends Table {
  TextColumn get accessToken => text()();

  TextColumn get idToken => text()();

  TextColumn get refreshToken => text().nullable()();
}
