import 'package:mind_metric/src/core/exceptions.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';
import 'package:mind_metric/src/data/database/job_dao.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : job_repository
/// Project : FlutterBase

class JobRepository {
  JobRepository._();

  static JobRepository? instance;

  late JobDao dao;

  factory JobRepository.init({required JobDao jobDao}) {
    instance = JobRepository._();
    instance!.dao = jobDao;
    instance!.dao.resetInProgressJobsToPending();
    return instance!;
  }

  Future<void> createSyncJob(Job job) {
    return dao.createJob(job);
  }

  Future<List<Job>> getNextJobs(String userId, int limit) async {
    final jobs = await dao.getNextJobs(userId, limit);
    if (jobs.isNotEmpty) {
      return jobs;
    } else {
      throw NoPendingJobException();
    }
  }

  Stream<String?> watchCurrentStatus(String jobType, String recordId) {
    return dao.watchJob(jobType, recordId).map((job) => job?.status);
  }

  Future<Job?> getJob(String type, String recordId) {
    return dao.getJob(type, recordId);
  }

  Future<Job> getJobById(String id) {
    return dao.getJobById(id);
  }

  Future<Job?> getJobByType(String jobType, String userId) {
    return dao.getJobByType(userId, jobType);
  }

  Stream<List<Job>> watchJobListByType(String jobType, String userId) {
    return dao.watchJobListByType(userId, jobType);
  }

  Future<List<Job>> getJobListByType(String jobType, String userId) {
    return dao.getJobListByType(userId, jobType);
  }

  Stream<List<Job>> watchJobListByTypeList(
    List<String> jobTypeList,
    String userId,
  ) {
    return dao.getJobListByTypeList(userId, jobTypeList);
  }

  Future<void> deleteJobById(String id) {
    return dao.deleteJobById(id);
  }

  Future<void> markJobAsFailed(String id) {
    return dao.markJobFailed(id);
  }

  Future<void> updateJobStatus(String jobId, String status) {
    return dao.updateJobStatus(status, jobId);
  }

  Future<void> markFailedJobsAsPending(String userId) {
    return dao.markFailedJobsAsPending(userId);
  }

  Future<int> getRemainingJobCount(String userId) {
    return dao.getRemainingJobCount(userId);
  }

  Future<int> getRemainingJobCountByStatus({
    required String userId,
    required String status,
  }) {
    return dao.getRemainingJobCountByStatus(userId: userId, status: status);
  }

  Future<void> updateAllJobStatus({
    required String userId,
    required String status,
  }) {
    return dao.updateAllJobsStatus(status, userId);
  }
}
