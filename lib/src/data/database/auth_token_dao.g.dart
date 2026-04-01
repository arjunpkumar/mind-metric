// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_dao.dart';

// ignore_for_file: type=lint
mixin _$AuthTokenDaoMixin on DatabaseAccessor<AppDatabase> {
  $AuthTokensTable get authTokens => attachedDatabase.authTokens;
  AuthTokenDaoManager get managers => AuthTokenDaoManager(this);
}

class AuthTokenDaoManager {
  final _$AuthTokenDaoMixin _db;
  AuthTokenDaoManager(this._db);
  $$AuthTokensTableTableManager get authTokens =>
      $$AuthTokensTableTableManager(_db.attachedDatabase, _db.authTokens);
}
