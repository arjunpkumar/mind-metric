import 'package:image_picker/image_picker.dart';
import 'package:mind_metric/src/application/bloc/splash/splash_bloc.dart';
import 'package:mind_metric/src/application/bloc/web_view/web_view_bloc.dart';
import 'package:mind_metric/src/data/core/repository_provider.dart';
import 'package:mind_metric/src/presentation/web_view/web_view_page.dart';
import 'package:mind_metric/src/utils/device_token_helper.dart';
import 'package:mind_metric/src/utils/file_util.dart';
import 'package:mind_metric/src/utils/notification_util.dart';

SplashBloc provideSplashBloc() {
  return SplashBloc(
    authRepository: provideAuthRepository(),
    userRepository: provideUserRepository(),
  );
}

WebViewBloc provideWebViewBloc(WebViewArgument argument) {
  return WebViewBloc(
    authRepository: provideAuthRepository(),
    isHeaderRequired: argument.isHeaderRequired,
    url: argument.url,
    title: argument.title,
    successUrl: argument.successUrl,
    alternateSuccessUrlList: argument.alternateSuccessUrlList,
    failureUrl: argument.failureUrl,
    isBackConfirmationRequired: argument.isBackConfirmationRequired,
    fileUtil: provideFileUtil(),
  );
}

DeviceTokenHelper provideDeviceTokenHelper() {
  return DeviceTokenHelper(
    deviceTokenRepository: provideDeviceTokenRepository(),
    userRepository: provideUserRepository(),
  );
}

NotificationUtil provideNotificationUtil() {
  return NotificationUtil(
    networkValidator: provideNetworkValidator(),
  );
}

FileUtil provideFileUtil() {
  return FileUtil(
    imagePicker: ImagePicker(),
  );
}
