import 'package:mind_metric/src/application/core/base_bloc_state.dart';

class WebViewState extends BaseBlocState {
  Map<String, String>? headers;
  bool isControllerInitiated = false;
  bool isPageLoading = false;

  WebViewState({
    this.headers,
    this.isControllerInitiated = false,
    this.isPageLoading = false,
  });

  @override
  WebViewState copyWith({
    Map<String, String>? headers,
    bool? isControllerInitiated,
    bool? isPageLoading,
  }) {
    return WebViewState(
      headers: headers ?? this.headers,
      isControllerInitiated:
          isControllerInitiated ?? this.isControllerInitiated,
      isPageLoading: isPageLoading ?? this.isPageLoading,
    )
      ..isInitCompleted = isInitCompleted
      ..canPop = canPop
      ..processState = processState;
  }
}

class PagePopped extends WebViewState {
  final String? url;

  PagePopped(this.url);
}
