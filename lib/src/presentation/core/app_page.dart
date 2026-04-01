import 'package:flutter/material.dart';
import 'package:flutter_base/src/application/core/process_state.dart';
import 'package:flutter_base/src/presentation/core/base_state.dart';
import 'package:flutter_base/src/presentation/core/theme/colors.dart';
import 'package:flutter_base/src/presentation/widgets/app_appbar.dart';
import 'package:flutter_base/src/presentation/widgets/error_widget.dart';
import 'package:flutter_base/src/presentation/widgets/loader_widget.dart';
import 'package:flutter_base/src/utils/extensions.dart';

/// Created by Jemsheer K D on 07 May, 2023.
/// File Name : app_page
/// Project : FlutterBase

class AppPage extends StatefulWidget {
  final Key drawerKey;
  final String title;
  final Color? backgroundColor;
  final Widget child;
  final bool isBackOrHamburgerRequired;
  final bool isAppBarRequired;
  final bool extendBodyBehindAppBar;
  final Function() retryOnTap;
  final Stream<ProcessState> processStateStream;
  final Stream<bool> initStateStream;
  final List<Widget> actions;
  final bool enableDrawerOpenDragGesture;
  final bool isCountRequired;
  final int count;
  final bool isSearching;
  final bool hasFixedBottomBar;
  final Function(String)? onSearchQueryChanged;

  final Widget? bottomNavigationBar;

  AppPage({
    required super.key,
    this.title = '',
    this.backgroundColor,
    required this.child,
    this.bottomNavigationBar,
    this.isBackOrHamburgerRequired = false,
    this.isAppBarRequired = true,
    this.extendBodyBehindAppBar = false,
    required this.retryOnTap,
    required this.processStateStream,
    required this.initStateStream,
    this.actions = const [],
    this.enableDrawerOpenDragGesture = true,
    this.isCountRequired = false,
    this.count = 0,
    this.isSearching = false,
    this.hasFixedBottomBar = false,
    this.onSearchQueryChanged,
  }) : drawerKey = Key("${key}Drawer");

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends BaseState<AppPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: StreamBuilder<bool>(
        stream: widget.initStateStream,
        builder: (context, initSnapshot) {
          return StreamBuilder<ProcessState>(
            stream: widget.processStateStream,
            builder: (context, snapshot) {
              final processState = snapshot.data ?? ProcessState.initial();
              final initState = initSnapshot.data ?? false;
              return Scaffold(
                backgroundColor: widget.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
                appBar:
                    widget.isAppBarRequired ? _getAppBarLayout(context) : null,
                drawer: widget.enableDrawerOpenDragGesture
                    // ? AppDrawer(drawerKey: widget.drawerKey)
                    ? Container()
                    : null,
                drawerEnableOpenDragGesture: widget.enableDrawerOpenDragGesture,
                extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
                body: _getBodyLayout(
                  context,
                  processState,
                  initState,
                ),
                bottomNavigationBar: widget.hasFixedBottomBar
                    ? widget.bottomNavigationBar
                    : !initState && processState.status == ProcessStatus.busy
                        ? null
                        : widget.bottomNavigationBar,
              );
            },
          );
        },
      ),
    );
  }

  AppAppbar _getAppBarLayout(BuildContext context) {
    return AppAppbar(
      title: widget.title,
      onUserTap: () {},
      isBackOrHamburgerRequired: widget.isBackOrHamburgerRequired,
      actions: widget.actions,
      isCountRequired: widget.isCountRequired,
      count: widget.count,
      isSearching: widget.isSearching,
      onSearchQueryChanged: widget.onSearchQueryChanged,
      searchController: _searchController,
    );
  }

  Widget _getBodyLayout(
    BuildContext context,
    ProcessState processState,
    bool initState,
  ) {
    if (!initState && processState.status == ProcessStatus.busy) {
      return const LoaderWidget();
    } else if (processState.status == ProcessStatus.error) {
      return ErrorMessageWidget(
        title: processState.message,
        description: processState.errorMsg,
        retryOnTap: () => widget.retryOnTap(),
      );
    } else {
      return _getContentLayout(context, initState, processState);
    }
  }

  Widget _getContentLayout(
    BuildContext context,
    bool initState,
    ProcessState processState,
  ) {
    return Stack(
      children: [
        Column(children: [Expanded(child: widget.child)]),
        if (processState.status == ProcessStatus.busy)
          AbsorbPointer(
            child: ColoredBox(
              color: AppColors.black.setOpacity(.5),
              child: const LoaderWidget(),
            ),
          ),
      ],
    );
  }
}
