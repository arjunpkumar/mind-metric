import 'dart:io';

import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_base/src/application/sync/job_manager.dart';
import 'package:flutter_base/src/data/core/config_repository.dart';
import 'package:flutter_base/src/data/core/log_services.dart';
import 'package:flutter_base/src/data/database/core/app_database.dart';
import 'package:flutter_base/src/utils/error_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'test_imports_helper.dart';

/// Created by Jemsheer K D on 24 February, 2025.
/// File Name : mock_provider_helper
/// Project : FlutterBase

const mockUserId = "1221";
const user = User(
  id: mockUserId,
  firstName: 'Test',
  lastName: 'Test',
);

typedef Callback = void Function(MethodCall call);

final List<MethodCall> methodCallLog = <MethodCall>[];

typedef MethodCallCallback = dynamic Function(MethodCall methodCall);

void setMockMethodCallHandler(
  MethodChannel channel,
  Future<Object?>? Function(MethodCall)? handler,
) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, handler);
}

Future<void> addDelay({int milliSeconds = 200}) async {
  await Future.delayed(Duration(milliseconds: milliSeconds));
}
/*

Future<void> loadLocalization() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final String contents =
  await File('lib/assets/strings/en-US.json').readAsString();
  final Map<String, dynamic> data =
  jsonDecode(contents) as Map<String, dynamic>;
  Localization.load(const Locale('en'), translations: Translations(data));
}
*/

Future<void> loadPathProviderMock() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return "test/assets/";
  });
}

Future<void> loadPackageInfoMock() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/package_info');
  setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{
        'appName': 'Ahoy',
        'packageName': 'com.ahoy.test',
        'version': '1.0.0',
        'buildNumber': '2',
      };
    }
    return null;
  });
}

void setupFirebaseAnalyticsMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  setMockMethodCallHandler(MethodChannelFirebaseAnalytics.channel,
      (MethodCall methodCall) async {
    methodCallLog.add(methodCall);
    switch (methodCall.method) {
      case 'Analytics#getAppInstanceId':
        return 'ABCD1234';

      default:
        return false;
    }
  });
}

void setupFirebaseCrashlyticsMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  setMockMethodCallHandler(MethodChannelFirebaseCrashlytics.channel,
      (MethodCall call) async {
    methodCallLog.add(call);
    switch (call.method) {
      case 'Crashlytics#recordError':
        return null;
      case 'Crashlytics#crash':
        return null;
      default:
        return false;
    }
  });
}

Future<void> loadAppBadgerMock() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('g123k/flutter_app_badger');
  setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'updateBadgeCount') {
      return null;
    }
    if (methodCall.method == 'removeBadge') {
      return null;
    }
    return;
  });
}

Future<void> loadFlutterLocalNotificationsPluginMock() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // const AndroidInitializationSettings androidInitializationSettings =
  //     AndroidInitializationSettings('app_icon');
  // const InitializationSettings initializationSettings =
  //     InitializationSettings(android: androidInitializationSettings);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  const MethodChannel channel =
      MethodChannel('dexterous.com/flutter/local_notifications');
  setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    methodCallLog.add(methodCall);
    if (methodCall.method == 'initialize') {
      return true;
    } else if (methodCall.method == 'pendingNotificationRequests') {
      return <Map<String, Object>>[];
    } else if (methodCall.method == 'getActiveNotifications') {
      return <Map<String, Object>>[];
    } else if (methodCall.method == 'getNotificationAppLaunchDetails') {
      return null;
    }
    return null;
  });
}

void initHive() {
  final path = Directory.current.path;
  Hive.init('$path/test/hive_testing_path');
}

@GenerateMocks([
  ConfigRepository,
  ErrorLogger,
  FirebaseMessaging,
  FirebaseRemoteConfig,
  Flavor,
  FlutterSecureStorage,
  JobManager,
  Logger,
])
@GenerateNiceMocks([
  MockSpec<AppDatabase>(
    as: #MockAppDatabase,
    unsupportedMembers: {#managers},
  ),
  MockSpec<Selectable<int>>(as: #MockCustomSelectOfInt),
])
class MockProviderHelper {
  static late MockErrorLogger mockErrorLogger;
  static late MockConfigRepository mockConfigRepository;
  static late MockFirebaseRemoteConfig mockRemoteConfig;
  static late MockLogger mockLogger;
  static late MockJobManager mockJobManager;

  static Future init() async {
    // await loadLocalization();

    mockConfigRepository = MockConfigRepository();
    mockRemoteConfig = MockFirebaseRemoteConfig();
    mockConfigRepository.setFirebaseRemoteConfig(mockRemoteConfig);
    ConfigRepository.fromMock(mockConfigRepository);

    mockErrorLogger = MockErrorLogger();
    ErrorLogger.fromMock(mockErrorLogger);

    when(
      mockErrorLogger.recordError(
        exception: anyNamed('exception'),
        stackTrace: anyNamed('stackTrace'),
      ),
    ).thenAnswer((_) {});

    mockLogger = MockLogger();
    Logger.fromMock(mockLogger);

    when(
      mockLogger.log(
        'document_updated',
        {
          'type': 'Document Type 1',
          'sub_type': 'Document Sub Type 1',
        },
      ),
    ).thenAnswer((_) => Future.value(dynamic));
    when(
      mockLogger.log(
        'document_deleted',
        {
          'id': 'Seafarer_Document_ID_1',
          'name': 'Document 1',
        },
      ),
    ).thenAnswer((_) => Future.value(dynamic));

    mockJobManager = MockJobManager();
    JobManager.fromMock(mockJobManager);
  }
}
