import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/application/bloc/web_view/web_view_bloc.dart';
import 'package:mind_metric/src/application/bloc/web_view/web_view_event.dart';
import 'package:mind_metric/src/application/bloc/web_view/web_view_state.dart';
import 'package:mind_metric/src/application/core/process_state.dart';
import 'package:mind_metric/src/presentation/core/app_page.dart';
import 'package:mind_metric/src/presentation/core/base_state.dart';
import 'package:mind_metric/src/presentation/core/theme/colors.dart';
import 'package:mind_metric/src/presentation/widgets/dialog/app_dialog.dart';
import 'package:mind_metric/src/presentation/widgets/loader_widget.dart';
import 'package:mind_metric/src/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_android;

class WebViewPage extends StatefulWidget {
  static const String route = "/web_view";

  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewState();
}

class _WebViewState extends BaseState<WebViewPage> {
  WebViewBloc? _bloc;

  WebViewController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_bloc == null) {
      _bloc = BlocProvider.of<WebViewBloc>(context);

      _bloc!.eventStream.listen(
        (event) {
          if (event.pagePopped && mounted) {
            Navigator.pop(context, event.url);
          }
        },
      );

      _bloc!.stream.listen(
        (state) {
          if (state.isInitCompleted && !state.isControllerInitiated) {
            _controller = WebViewController()
              ..loadRequest(
                Uri.parse(_bloc!.url),
                headers: _bloc!.isHeaderRequired ? state.headers ?? {} : {},
              )
              ..setNavigationDelegate(
                NavigationDelegate(
                  onNavigationRequest: (request) {
                    if (!mounted) return NavigationDecision.prevent;
                    if (request.url.contains("mailto:")) {
                      launchUrlString(request.url);
                      return NavigationDecision.prevent;
                    }
                    if (_bloc!.successUrl != null ||
                        _bloc!.failureUrl != null) {
                      if (request.url.startsWith(_bloc!.successUrl ?? " ")) {
                        Navigator.pop(context, request.url);
                        return NavigationDecision.prevent;
                      } else if (request.url
                          .startsWith(_bloc!.failureUrl ?? " ")) {
                        Navigator.pop(context);
                        return NavigationDecision.prevent;
                      }
                    }
                    return NavigationDecision.navigate;
                  },
                  onProgress: (value) {
                    if (_bloc!.isClosed) return;
                    _bloc!.add(
                      WebViewEvent()
                        ..processState = value < 100
                            ? ProcessState.busy()
                            : ProcessState.completed(),
                    );
                  },
                  onWebResourceError: (error) async {
                    final currentUrl = await _controller!.currentUrl();
                    debugPrint(error.toString());
                    if (currentUrl == null) {
                      _bloc!.add(
                        WebViewEvent()
                          ..processState =
                              ProcessState.error(errorMsg: error.toString()),
                      );
                    } else if (!currentUrl.startsAnyWith(
                      [
                        _bloc!.successUrl,
                        _bloc!.failureUrl,
                        ...?_bloc!.alternateSuccessUrlList,
                      ],
                    )) {
                      _bloc!.add(
                        WebViewEvent()
                          ..processState =
                              ProcessState.error(errorMsg: error.toString()),
                      );
                      debugPrint(error.toString());
                    } else {
                      if (mounted) {
                        await _displayTemporaryLoader(
                          context,
                          state,
                          currentUrl,
                        );
                      }
                    }
                  },
                  onPageStarted: (url) {
                    if (_bloc!.isHeaderRequired && url != _bloc!.currentUrl) {
                      _bloc!.currentUrl = url;
                      _controller?.loadRequest(
                        Uri.parse(url),
                        headers: state.headers!,
                      );
                    }
                    _bloc!.isPageLoading = true;
                    _bloc!.add(
                      WebViewEvent()..processState = ProcessState.busy(),
                    );
                  },
                  onPageFinished: (url) async {
                    _bloc!.isPageLoading = false;

                    if (!url.startsAnyWith(
                      [_bloc?.successUrl, _bloc?.failureUrl],
                    )) {
                      _bloc!.add(
                        WebViewEvent()..processState = ProcessState.completed(),
                      );
                    } else if (url
                        .startsAnyWith(_bloc!.alternateSuccessUrlList)) {
                      await _displayTemporaryLoader(context, state, url);
                    }
                  },
                ),
              )
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setUserAgent(
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
              );
            if (!kIsWeb && Platform.isAndroid && mounted) {
              _initAndroidFileUploader(context);
            }
            _bloc!.add(WebViewControllerInitiatedEvent());
          }
        },
      );
    }
  }

  Future<void> _displayTemporaryLoader(
    BuildContext context,
    WebViewState state,
    String url,
  ) async {
    late BuildContext loaderContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        loaderContext = context;
        return PopScope(
          canPop: state.canPop,
          child: const LoaderWidget(),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 5)).then((value) {
      if (loaderContext.mounted) Navigator.pop(loaderContext);
      if (context.mounted) Navigator.pop(context, url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WebViewBloc, WebViewState>(
      bloc: _bloc,
      listener: (context, state) {},
      builder: (context, state) {
        return PopScope(
          canPop: state.canPop,
          onPopInvokedWithResult: (didPop, _) async {
            if (!didPop) {
              final url = await _controller?.currentUrl();
              if (_bloc!.isBackConfirmationRequired) {
                if (!mounted) return;
                if (!_bloc!.isPageLoading &&
                    (url?.startsAnyWith(_bloc!.alternateSuccessUrlList) ??
                        false)) {
                  _bloc!.add(PopInvoked(url: url));
                } else {
                  openAppDialog(
                    this.context,
                    title: S.current.labelCancelXConfirmation(_bloc!.title),
                    positiveButtonText: S.current.btnYesCancel,
                    negativeButtonText: S.current.btnNo,
                  ).then(
                    (value) {
                      final result = toDefaultBool(value);
                      if (result) {
                        _controller?.runJavaScript('window.stop();');
                        _bloc!.add(PopInvoked());
                      }
                    },
                  );
                }
              } else if (!_bloc!.isPageLoading) {
                _bloc!.add(PopInvoked(url: url));
              }
            }
          },
          child: AppPage(
            key: Key("App_Page_WebView_${_bloc!.title}"),
            title: _bloc!.title.toUpperCase(),
            isBackOrHamburgerRequired: true,
            initStateStream:
                _bloc!.stream.map((state) => state.isInitCompleted),
            processStateStream: _bloc!.stream.map((s) => s.processState),
            retryOnTap: () {},
            child: _getBodyLayout(context, state),
          ),
        );
      },
    );
  }

  Widget _getBodyLayout(BuildContext context, WebViewState state) {
    return Stack(
      children: [
        if (state.isInitCompleted && state.isControllerInitiated)
          WebViewWidget(controller: _controller!),
        if (state.processState.status == ProcessStatus.busy)
          const ColoredBox(
            color: AppColors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (state.processState.status == ProcessStatus.error)
          ColoredBox(
            color: AppColors.white,
            child: Center(
              child: Text(
                S.current.errWebView,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _initAndroidFileUploader(BuildContext context) async {
    if (Platform.isAndroid) {
      final controller =
          _controller!.platform as webview_android.AndroidWebViewController;
      await controller.setOnShowFileSelector(_androidFilePicker);
    }
  }

  Future<List<String>> _androidFilePicker(
    webview_android.FileSelectorParams params,
  ) async {
    final xFile = await _bloc!.fileUtil
        .openDocumentPickerXFile(
      context,
      // useFileSelectorOnly: true,
    )
        .onError(
      (e, stackTrace) {
        debugPrint(e.toString());
        return null;
      },
    );

    if (xFile == null) {
      return [];
    }

    final path = _bloc!.fileUtil.getProcessedFileUri(xFile.path);
    return [path];
  }
}

class WebViewArgument {
  String title;
  String url;
  List<String>? alternateSuccessUrlList;
  String? successUrl;
  String? failureUrl;
  bool isHeaderRequired;
  bool isBackConfirmationRequired;

  WebViewArgument({
    required this.title,
    required this.url,
    this.alternateSuccessUrlList,
    this.successUrl,
    this.failureUrl,
    this.isHeaderRequired = false,
    this.isBackConfirmationRequired = false,
  });
}
