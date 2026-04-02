import 'package:mind_metric/src/application/sync/syncable.dart';
import 'package:mind_metric/src/core/exceptions.dart';

/// Created by Jemsheer K D on 21 February, 2025.
/// File Name : syncable_provider
/// Project : FlutterBase

class SyncableProvider {
  static SyncableProvider? instance;

  factory SyncableProvider() {
    return instance ??= SyncableProvider._();
  }

  SyncableProvider._();

  SyncAble getRepository(String type) {
    switch (type) {
      /*case kBasicDetailsJob:
        return provideBasicDetailRepository();*/

      /*case kReimbursementOnBoardJob:
        return provideReimbursementRepository();*/
      default:
        throw CustomException(
          'SYNC_ERROR',
          message: '$type not Implemented',
        );
    }
  }

  List<SyncAble> getAllRepositories() {
    return [
      // provideBasicDetailRepository(),
    ];
  }
}
