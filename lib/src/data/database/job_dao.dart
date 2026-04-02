import 'package:drift/drift.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';

part 'job_dao.g.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : job_dao
/// Project : FlutterBase

@DriftAccessor(
  tables: [Jobs],
  queries: {
    'deleteJobById': 'DELETE FROM jobs WHERE id = :jobId',
    'deleteJobByType':
        'DELETE FROM jobs WHERE type = :type AND user_id = :userId',
    'updateJobStatus': "UPDATE jobs SET status = :status  WHERE id = :jobId",
    'markJobFailed':
        "UPDATE jobs SET status = '${JobStatus.failed}' , failure_count = failure_count + 1 WHERE id = :jobId",
    'markFailedJobsAsPending':
        "UPDATE jobs SET status = '${JobStatus.pending}' WHERE status = '${JobStatus.failed}' AND user_id = :userId",
    'updateAllJobsStatus':
        "UPDATE jobs SET status = :status WHERE user_id = :userId",
  },
)
class JobDao extends DatabaseAccessor<AppDatabase> with _$JobDaoMixin {
  JobDao(super.db);

  Future<void> createJob(Job entry) {
    return into(jobs).insert(entry);
  }

  Future<List<Job>> getNextJobs(String userId, int limit) {
    return (select(jobs)
          ..where((job) => job.status.equals(JobStatus.pending))
          ..where((job) => job.userId.equals(userId))
          ..orderBy([
            (job) =>
                OrderingTerm(expression: job.priority, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  Future<void> resetInProgressJobsToPending() {
    return (update(jobs)
          ..where((job) => job.status.equals(JobStatus.inProgress)))
        .write(
      const JobsCompanion(
        status: Value(JobStatus.pending),
      ),
    );
  }

  Future<Job> getJobById(String jobId) {
    return (select(jobs)..where((job) => job.id.equals(jobId))).getSingle();
  }

  Future<Job?> getJobByType(String userId, String jobType) {
    return (select(jobs)
          ..where((job) => job.type.equals(jobType))
          ..where((job) => job.userId.equals(userId))
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<Job>> watchJobListByType(String userId, String jobType) {
    return (select(jobs)
          ..where((job) => job.type.equals(jobType))
          ..where((job) => job.userId.equals(userId)))
        .watch();
  }

  Future<List<Job>> getJobListByType(String userId, String jobType) {
    return (select(jobs)
          ..where((job) => job.type.equals(jobType))
          ..where((job) => job.userId.equals(userId)))
        .get();
  }

  Stream<List<Job>> getJobListByTypeList(
    String userId,
    List<String> jobTypeList,
  ) {
    return (select(jobs)
          ..where((job) => job.type.isIn(jobTypeList))
          ..where((job) => job.userId.equals(userId)))
        .watch();
  }

  Future<int> getRemainingJobCount(String userId) async {
    final jobList =
        await (select(jobs)..where((job) => job.userId.equals(userId))).get();
    return jobList.length;
  }

  Future<int> getRemainingJobCountByStatus({
    required String userId,
    required String status,
  }) async {
    final jobList = await (select(jobs)
          ..where((job) => job.userId.equals(userId))
          ..where((job) => job.status.equals(status)))
        .get();
    return jobList.length;
  }

  Future<Job?> getJob(String type, String recordId) {
    return (select(jobs)
          ..where((job) => job.type.equals(type))
          ..where((job) => job.recordId.equals(recordId))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.rowId,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<Job?> watchJob(String type, String recordId) {
    return (select(jobs)
          ..where((job) => job.type.equals(type))
          ..where((job) => job.recordId.equals(recordId)))
        .watchSingleOrNull();
  }
}

class Jobs extends Table {
  TextColumn get id => text()();

  TextColumn get recordId => text()();

  TextColumn get type => text()();

  TextColumn get userId => text()();

  IntColumn get priority => integer().withDefault(const Constant(1))();

  TextColumn get status => text()();

  IntColumn get failureCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Priority {
  Priority._();

  static const int high = 2;
  static const int medium = 1;
  static const int low = 0;
}

class JobStatus {
  JobStatus._();

  static const String onHold = "on_hold";
  static const String pending = "pending";
  static const String inProgress = "in_progress";
  static const String failed = "failed";
  static const String deleted = "deleted";
  static const String completed = "completed";
}
