import 'package:flutter_base/src/application/core/base_bloc.dart';
import 'package:flutter_base/src/application/web_view/web_view_event.dart';
import 'package:flutter_base/src/application/web_view/web_view_state.dart';
import 'package:flutter_base/src/domain/auth/auth_repository.dart';
import 'package:flutter_base/src/utils/file_util.dart';
import 'package:flutter_base/src/utils/network_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebViewBloc extends BaseBloc<WebViewEvent, WebViewState> {
  final AuthRepository authRepository;
  final FileUtil fileUtil;
  final bool isHeaderRequired;
  final bool isBackConfirmationRequired;
  final String url;
  final String title;
  final String? successUrl;
  final String? alternateSuccessUrl;
  final String? failureUrl;

  String? currentUrl;
  bool isPageLoading = false;

  WebViewBloc({
    required this.authRepository,
    required this.isHeaderRequired,
    required this.url,
    required this.title,
    required this.fileUtil,
    this.successUrl,
    this.alternateSuccessUrl,
    this.failureUrl,
    this.isBackConfirmationRequired = false,
  }) : super(WebViewState()..canPop = false) {
    on<PopInvoked>((event, emit) => _onPopInvoked(event, emit));
    on<WebViewEvent>(
      (event, emit) => emit(
        state.copyWith()..processState = event.processState,
      ),
    );
    on<InitWebViewEvent>((event, emit) => _onWebViewInit(event, emit));
    on<WebViewControllerInitiatedEvent>(
      (event, emit) => emit(state.copyWith(isControllerInitiated: true)),
    );

    add(InitWebViewEvent());
  }

  void _onPopInvoked(PopInvoked event, Emitter<WebViewState> emit) {
    emit(PagePopped(event.url)..canPop = true);
  }

  Future<void> _onWebViewInit(
    InitWebViewEvent event,
    Emitter<WebViewState> emit,
  ) async {
    if (isHeaderRequired) {
      await setHeader(emit);
    } else {
      emit(state.copyWith(isInitCompleted: true));
    }
  }

  Future<void> setHeader(Emitter<WebViewState> emit) async {
    final map = await getHeader();
    emit(
      state.copyWith(
        headers: map.map((key, value) => MapEntry(key, value.toString())),
        isInitCompleted: true,
      ),
    );
  }

  Future<Map<String, dynamic>> getHeader() async {
    final authToken = await authRepository.getActiveToken();
    return getHeaders(authToken: authToken);
  }
}
