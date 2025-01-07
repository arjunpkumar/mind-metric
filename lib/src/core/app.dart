import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/config.dart';
import 'package:flutter_base/firebase_options.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/src/application/core/bloc_provider.dart';
import 'package:flutter_base/src/core/app_constants.dart';
import 'package:flutter_base/src/core/routes.dart';
import 'package:flutter_base/src/domain/core/config_repository.dart';
import 'package:flutter_base/src/domain/core/log_services.dart';
import 'package:flutter_base/src/domain/core/repository_provider.dart';
import 'package:flutter_base/src/presentation/core/theme/text_styles.dart';
import 'package:flutter_base/src/presentation/widgets/app_version_widget.dart';
import 'package:flutter_base/src/utils/deeplink_handler.dart';
import 'package:flutter_base/src/utils/deeplink_navigator.dart';
import 'package:flutter_base/src/utils/error_logger.dart';
import 'package:flutter_base/src/utils/file_util.dart';
import 'package:flutter_base/src/utils/guard.dart';
import 'package:flutter_base/src/utils/notifications_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  if (kIsWeb || !(Platform.isWindows || Platform.isMacOS)) {
    await FirebaseRemoteConfig.instance.ensureInitialized();
  }

  if (!kIsWeb) {
    Hive.init(await FileUtil.getApplicationPath());
  }

  // Disable DebugPrint in Release Mode
  if (Config.appMode == AppMode.release) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  if (kIsWeb ||
      Platform.isAndroid ||
      Platform.isFuchsia ||
      Platform.isIOS ||
      Platform.isMacOS ||
      Platform.isWindows ||
      Platform.isLinux) {
    Config.packageInfo = await PackageInfo.fromPlatform();
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isFuchsia) {
        Config.androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      }
      if (Platform.isIOS) {
        Config.iOSDeviceInfo = await DeviceInfoPlugin().iosInfo;
      }
    }
  }

  // Sync Configs
  await Guard.runAsync(
    () async {
      final configsRepository = ConfigRepository.instance();

      if (kIsWeb || !(Platform.isWindows || Platform.isMacOS)) {
        await configsRepository.initConfig();
        await configsRepository.syncConfig();
      } else if (Platform.isWindows || Platform.isMacOS) {
        await provideRemoteConfigRepository().fetchAndUpdateRemoteConfigList();
      }
    },
    onError: (e, s) async {
      Guard.runAsync(() async {
        await provideRemoteConfigRepository().fetchAndUpdateRemoteConfigList();
      });
    },
  );

  /*  if(Config.appFlavor is! Production && Config.appMode != AppMode.release){
    final driver = StorageServerDriver(
        bundleId: Config.packageInfo.packageName, //Used for identification
        port: 0, //Default 0, use 0 to automatically use a free port
    );
    driver.addSQLServer(SQLDatabaseServer);
  }*/
}

Future<void> initApp() async {
  runZonedGuarded<Future<void>>(
    () async {
      await _init();
      runApp(App());
    },
    (error, stackTrace) {
      if (Config.appMode == AppMode.release) {
        ErrorLogger().recordError(
          exception: error,
          stackTrace: stackTrace,
        );
      }
    },
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late DeeplinkHandler _deeplinkHandler;
  late NotificationsHandler _notificationsHandler;

  @override
  void initState() {
    super.initState();

    _setupHandlers();

    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // removeBadge();
        break;
      default:
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  Future<void> removeBadge() async {
    try {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        return;
      }
      // FlutterAppBadger.removeBadge();
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) => Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
                return child!;
              }
              return AppVersionWidget(
                configsRepository: ConfigRepository.instance(),
                child: child!,
              );
            },
          );
        },
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: FirebaseAnalytics.instance,
          nameExtractor: (settings) => screenName(settings.name ?? "Other"),
        ),
      ],
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: TextStyles.h1ExtraLight(context),
          displayMedium: TextStyles.h2ExtraLight(context),
          displaySmall: TextStyles.h2Light(context),
          headlineMedium: TextStyles.titleSemiBold(context),
          titleLarge: TextStyles.title2Bold(context),
          titleSmall: TextStyles.title3Bold(context),
          titleMedium: TextStyles.title2Medium(context),
          bodyMedium: TextStyles.body1Regular(context),
          bodyLarge: TextStyles.body1Bold(context),
          bodySmall: TextStyles.captionRegular(context),
          labelSmall: TextStyles.captionBold(context),
          labelLarge: TextStyles.buttonBlack(context),
        ),
        dialogTheme: DialogTheme(
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          contentTextStyle: Theme.of(context).textTheme.bodyMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Units.kCardBorderRadius),
          ),
        ),
        cardTheme: CardTheme(
          elevation: Units.kCardElevation,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Units.kCardBorderRadius),
          ),
        ),
      ),
      routes: routes,
      onGenerateRoute: (settings) => generatedRoutes(settings),
      scrollBehavior: AppScrollBehavior(),
    );
  }

  Future<void> _setupHandlers() async {
    final prefs = await SharedPreferences.getInstance();
    final navigator = DeeplinkNavigator(prefs: prefs);

    // Configure Push Notifications
    final messagingService = provideFireBaseMessaging();

    _notificationsHandler = NotificationsHandler(
      messagingService: messagingService,
      authRepository: provideAuthRepository(),
      userRepository: provideUserRepository(),
      navigator: navigator,
      notificationUtil: provideNotificationUtil(),
    );
    _notificationsHandler.setup();
    // Configure Deep Link
    _deeplinkHandler = DeeplinkHandler(navigator: navigator);
    await _deeplinkHandler.setup();
    // LocalNotificationService().setNavigator(navigator);
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      };
}
