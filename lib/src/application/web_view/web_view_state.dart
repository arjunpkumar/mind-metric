import 'package:flutter_base/src/application/core/base_bloc_state.dart';

class WebViewState extends BaseBlocState {
  Map<String, String>? headers;
  bool isInitCompleted = false;
  bool isControllerInitiated = false;
  bool isPageLoading = false;

  WebViewState({
    this.headers,
    this.isInitCompleted = false,
    this.isControllerInitiated = false,
    this.isPageLoading = false,
  });

  @override
  WebViewState copyWith({
    Map<String, String>? headers,
    bool? isInitCompleted,
    bool? isControllerInitiated,
    bool? isPageLoading,
  }) {
    return WebViewState(
      headers: headers ?? this.headers,
      isControllerInitiated:
          isControllerInitiated ?? this.isControllerInitiated,
      isInitCompleted: isInitCompleted ?? this.isInitCompleted,
      isPageLoading: isPageLoading ?? this.isPageLoading,
    );
  }
}

class PagePopped extends WebViewState {
  final String? url;

  PagePopped(this.url);
}
