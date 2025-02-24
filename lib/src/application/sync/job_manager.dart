import 'package:flutter/foundation.dart';
import 'package:flutter_base/src/application/sync/syncable_provider.dart';
import 'package:flutter_base/src/core/app_constants.dart';
import 'package:flutter_base/src/core/exceptions.dart';
import 'package:flutter_base/src/data/auth/user_repository.dart';
import 'package:flutter_base/src/data/core/sync/job_repository.dart';
import 'package:flutter_base/src/data/database/core/app_database.dart';
import 'package:flutter_base/src/data/database/job_dao.dart';
import 'package:flutter_base/src/utils/network_validator.dart';
import 'package:rxdart/rxdart.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : job_manager
/// Project : FlutterBase

class JobManager {
  late NetworkValidator _networkValidator;
  late UserRepository _userRepository;
  late JobRepository _jobRepository;
  late SyncableProvider _syncableProvider;

  JobManager._();

  static const kMaxJobLimit = 1;
  static JobManager? instance;
  final isSyncingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isSyncing => isSyncingSubject.stream;

  ///Should Only Be Used for writing Unit Test Cases
  ///[jobManagerInstance] needs to be a mocked instance of JobManager
  @visibleForTesting
  factory JobManager.fromMock(JobManager jobManagerInstance) {
    return instance = jobManagerInstance;
  }

  factory JobManager.init({
    required UserRepository userRepository,
    required NetworkValidator networkValidator,
    required JobRepository jobRepository,
    required SyncableProvider syncableProvider,
  }) {
    instance = JobManager._()
      .._jobRepository = jobRepository
      .._userRepository = userRepository
      .._networkValidator = networkValidator
      .._syncableProvider = syncableProvider
      .._resetExhausted();
    return instance!;
  }

  Future<void> sync() async {
    final user = await _userRepository.getCurrentUser();
    if (user == null || isSyncingSubject.value == true) {
      return;
    }

    Future<void> syncJobs() async {
      await _networkValidator.validateNetworkReachability();
      final jobs = await _jobRepository.getNextJobs(user.id, kMaxJobLimit);

      await Future.wait(jobs.map(syncJob));
      await syncJobs();
    }

    isSyncingSubject.add(true);
    try {
      await syncJobs();
    } catch (_) {}
    isSyncingSubject.add(false);
    try {
      await _jobRepository.markFailedJobsAsPending(user.id);
    } catch (_) {}
  }

  Future<void> syncJob(Job job) async {
    try {
      await _jobRepository.updateJobStatus(
        job.id,
        JobStatus.inProgress,
      );
      final repository = _syncableProvider.getRepository(job.type);
      await repository.syncPendingItems(job.userId, job.recordId);
      await _jobRepository.deleteJobById(job.id);
    } catch (exception) {
      if (exception is NoNetworkException) {
        return;
      }
      await _jobRepository.markJobAsFailed(job.id);
      final failedJob = await _jobRepository.getJobById(job.id);
      if (failedJob.failureCount >= maxFailuresCount) {
        final repository = _syncableProvider.getRepository(job.type);
        repository.onRetryExhausted(job.userId, job.recordId);
        await _jobRepository.deleteJobById(failedJob.id);
      }
    }
  }

  Future<void> _resetExhausted() async {
    final repositoryList = _syncableProvider.getAllRepositories();

    for (final repo in repositoryList) {
      repo.resetExhausted();
    }
  }
}
