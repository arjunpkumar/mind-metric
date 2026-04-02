import 'package:drift/drift.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';

part 'notification_dao.g.dart';

@DriftAccessor(
  tables: [Notifications],
)
class NotificationDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationDaoMixin {
  NotificationDao(super.db);

  Stream<List<NotificationData>> watchNotifications() {
    return (select(notifications)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.updatedAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .watch();
  }

  Future<List<NotificationData>> getNotifications({
    DateTime? until,
    required int batchSize,
  }) {
    if (until == null) {
      return (select(notifications)
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.updatedAt,
                    mode: OrderingMode.desc,
                  ),
            ])
            ..limit(batchSize))
          .get();
    } else {
      return (select(notifications)
            ..where((t) => t.updatedAt.isSmallerThanValue(until))
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.updatedAt,
                    mode: OrderingMode.desc,
                  ),
            ])
            ..limit(batchSize))
          .get();
    }
  }

  Future<NotificationData?> getLatestNotification() async {
    final records = await (select(notifications)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .get();
    if (records.isNotEmpty) {
      return records.first;
    } else {
      return null;
    }
  }

  Future<int?> getNotificationCount() {
    final countExp = notifications.id.count();
    final query = selectOnly(notifications)..addColumns([countExp]);
    return query.map((row) => row.read(countExp)).getSingleOrNull();
  }

  Future<void> saveNotifications(List<NotificationData> notificationList) {
    return batch(
      (batch) => batch.insertAll(
        notifications,
        notificationList,
        mode: InsertMode.replace,
      ),
    );
  }

  Future<void> updateAllNotificationAsRead() async {
    await update(notifications).write(
      const NotificationsCompanion(
        isRead: Value(true),
      ),
    );
  }

  Future<void> deleteAllNotifications() async {
    await delete(notifications).go();
  }

  Future<void> updateNotificationAsRead(String id) async {
    await (update(notifications)
          ..where(
            (t) => t.id.equals(id),
          ))
        .write(
      const NotificationsCompanion(
        isRead: Value(true),
      ),
    );
  }
}

@DataClassName('NotificationData')
class Notifications extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get body => text()();

  TextColumn get notificationType => text().nullable()();

  TextColumn get notifierId => text().nullable()();

  TextColumn get notifierType => text().nullable()();

  BoolColumn get isRead => boolean().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
