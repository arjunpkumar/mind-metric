import 'package:drift/drift.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<User?> getCurrentUser() {
    return select(users).getSingleOrNull();
  }

  Stream<User> watchGetActiveUser() {
    return select(users).watchSingle();
  }

  Future<int> saveUser(User entry) {
    return into(users).insert(entry, mode: InsertMode.replace);
  }

  Future<void> deleteUsers() {
    return delete(users).go();
  }

  Future<User?> userById(String id) {
    return (select(users)..where((user) => user.id.equals(id)))
        .getSingleOrNull();
  }
}

class Users extends Table {
  TextColumn get id => text()();

  TextColumn get firstName => text()();

  TextColumn get lastName => text()();

  TextColumn get designation => text().nullable()();

  TextColumn get email => text().nullable()();

  TextColumn get profilePhoto => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
