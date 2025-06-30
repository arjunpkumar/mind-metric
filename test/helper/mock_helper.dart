import 'dart:io';

import 'package:drift/native.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
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

Future<void> loadLocalization() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final String contents = await File('lib/l10n/intl_en.arb').readAsString();
  final Map<String, dynamic> data =
      jsonDecode(contents) as Map<String, dynamic>;

  // Mock the method that Flutter uses to load localization
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/localization', (message) {
    final Map<String, dynamic> fakeLocalizationData = {
      "flutterLocale": "en",
      "translations": data,
    };

    final Uint8List encodedData =
        Uint8List.fromList(utf8.encode(json.encode(fakeLocalizationData)));
    final ByteData byteData = ByteData.sublistView(encodedData);

    return Future.value(byteData); // Corrected return type
  });

  await S.load(const Locale('en')); // Load localization
}

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
        'appName': 'Flutter Base',
        'packageName': 'com.thinkpalm.flutterbase',
        'version': '1.0.0',
        'buildNumber': '2',
      };
    }
    return null;
  });
}

Future<void> _initFirebase() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  setupFirebaseCrashlyticsMocks();
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

class MockHelper {
  static late MockErrorLogger mockErrorLogger;
  static late MockConfigRepository mockConfigRepository;
  static late MockFirebaseRemoteConfig mockRemoteConfig;
  static late MockLogger mockLogger;
  static late MockJobManager mockJobManager;
  static late AppDatabase appDatabase;
  static late MockFirebaseCrashlytics mockFirebaseCrashlytics;
  static late MockAuthRepository mockAuthRepository;
  static late MockUserRepository mockUserRepository;
  static late MockFileUtil mockFileUtil;
  static late MockFlavor mockFlavor;
  static bool isInitCompleted = false;

  static Future init() async {
    setupFirebaseCrashlyticsMocks();
    await loadLocalization();
    await _initFirebase();

    mockAuthRepository = MockAuthRepository();
    mockUserRepository = MockUserRepository();
    mockFirebaseCrashlytics = MockFirebaseCrashlytics();
    mockConfigRepository = MockConfigRepository();
    mockRemoteConfig = MockFirebaseRemoteConfig();
    mockConfigRepository.setFirebaseRemoteConfig(mockRemoteConfig);
    ConfigRepository.fromMock(mockConfigRepository);

    mockFlavor = MockFlavor();
    Config.appFlavor = mockFlavor;

    mockErrorLogger = MockErrorLogger();
    ErrorLogger.fromMock(mockErrorLogger);

    mockLogger = MockLogger();
    Logger.fromMock(mockLogger);

    if (AppDatabase.isInitCompleted()) {
      appDatabase = AppDatabase.instance();
    } else {
      appDatabase = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );
      AppDatabase.fromMock(appDatabase);
    }

    mockJobManager = MockJobManager();
    JobManager.fromMock(mockJobManager);
    mockFileUtil = MockFileUtil();
    FileUtil.fromMock(mockFileUtil);

    isInitCompleted = true;
  }

  static void initStubs() {
    when(
      mockErrorLogger.recordError(
        exception: anyNamed('exception'),
        stackTrace: anyNamed('stackTrace'),
      ),
    ).thenAnswer((_) {});

    when(mockFileUtil.getApplicationPath())
        .thenAnswer((_) => Future.value("/"));
    when(mockFileUtil.getExternalPath()).thenAnswer((_) => Future.value("/"));
    when(mockFileUtil.getDownloadPath()).thenAnswer((_) => Future.value("/"));
    when(mockFileUtil.getApplicationTempPath())
        .thenAnswer((_) => Future.value("/"));

    when(mockUserRepository.getCurrentUser())
        .thenAnswer((_) => Future.value(user));
    when(mockUserRepository.getActiveUser())
        .thenAnswer((_) => Future.value(user));
    when(mockUserRepository.userById(user.id))
        .thenAnswer((_) => Future.value(user));
    when(mockAuthRepository.isSessionActive())
        .thenAnswer((_) => Future.value(true));

    mockJobManager = MockJobManager();
    JobManager.fromMock(mockJobManager);
  }

  static Future dispose() async {
    if (isInitCompleted) {
      await appDatabase.close();
    }
  }
}

@GenerateMocks([
  AuthRepository,
  // AuthServices,
  AuthSettingsDao,
  AuthUtil,
  ConfigRepository,
  Connectivity,
  ErrorLogger,
  FileDownloader,
  FileUtil,
  Flavor,
  FlutterSecureStorage,
  JobConnectivity,
  JobManager,
  JobRepository,
  JobTimer,
  JobUtils,
  Logger,
  SettingsDao,
  UserMapper,
  UserRepository,
  // UserServices,
])
@GenerateNiceMocks([
  // MockSpec<AppDatabase>(
  //   as: #MockAppDatabase,
  //   unsupportedMembers: {#managers},
  // ),
  // MockSpec<Selectable<int>>(as: #MockCustomSelectOfInt),
])
class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}
