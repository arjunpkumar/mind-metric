import 'package:flutter_base/src/application/core/base_bloc_event.dart';

class WebViewEvent extends BaseBlocEvent {}

class PopInvoked extends WebViewEvent {
  String? url;

  PopInvoked({this.url});
}

class InitWebViewEvent extends WebViewEvent {}

class WebViewControllerInitiatedEvent extends WebViewEvent {}
