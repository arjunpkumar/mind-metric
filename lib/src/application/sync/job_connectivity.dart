import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mind_metric/src/application/sync/job_manager.dart';
import 'package:mind_metric/src/application/sync/job_timer.dart';
import 'package:mind_metric/src/data/auth/auth_repository.dart';
import 'package:mind_metric/src/utils/network_validator.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : job_connectivity
/// Project : FlutterBase

class JobConnectivity {
  final JobTimer jobTimer;
  final NetworkValidator networkValidator;
  final JobManager jobManager;
  final AuthRepository authRepository;
  final Connectivity connectivity;

  JobConnectivity({
    required this.jobTimer,
    required this.networkValidator,
    required this.jobManager,
    required this.authRepository,
    required this.connectivity,
  });

  StreamSubscription? _subscription;

  Future<void> init() async {
    final isSessionActive = await authRepository.isSessionActive();

    await networkValidator
        .validateNetworkReachability()
        .then((_) => jobTimer.startTimer(isSessionActive))
        .catchError((_) => null);

    _subscription ??= connectivity.onConnectivityChanged.listen((result) {
      if (isNetworkAvailable(result)) {
        jobManager.sync();
        jobTimer.startTimer(isSessionActive);
      } else {
        jobTimer.stopTimer();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
