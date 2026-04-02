import 'package:flutter/material.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/presentation/core/theme/text_styles.dart';

class AppAppbar extends PreferredSize {
  AppAppbar({
    super.key,
    required VoidCallback onUserTap,
    required bool isBackOrHamburgerRequired,
    String? screen,
    String? title,
    List<Widget> actions = const [],
    bool isCountRequired = false,
    int count = 0,
    bool isSearching = false,
    Function(String)? onSearchQueryChanged,
    TextEditingController? searchController,
  }) : super(
          preferredSize: const Size.fromHeight(Units.kAppBarHeight),
          child: _AppAppbar(
            key: key,
            onUserTap: onUserTap,
            shouldShowBackIcon: isBackOrHamburgerRequired,
            screen: screen,
            title: title,
            actions: actions,
            isCountRequired: isCountRequired,
            count: count,
            isSearching: isSearching,
            onSearchQueryChanged: onSearchQueryChanged,
            searchController: searchController,
          ),
        );
}

class _AppAppbar extends StatelessWidget {
  final String? screen;
  final VoidCallback onUserTap;
  final String? title;
  final bool shouldShowBackIcon;
  final List<Widget> actions;
  final bool isCountRequired;
  final int count;
  final bool isSearching;

  final Function(String p1)? onSearchQueryChanged;
  final TextEditingController? searchController;

  const _AppAppbar({
    super.key,
    required this.onUserTap,
    required this.shouldShowBackIcon,
    this.screen,
    this.title,
    this.actions = const [],
    this.isCountRequired = false,
    this.count = 0,
    this.isSearching = false,
    this.onSearchQueryChanged,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (!isSearching) searchController?.clear();
    return AppBar(
      toolbarHeight: Units.kAppBarHeight,
      iconTheme: IconThemeData(
        color: colors.onPrimary, //change your color here
      ),
      key: key,
      elevation: 0,
      automaticallyImplyLeading: shouldShowBackIcon,
      backgroundColor: colors.primary,
      titleSpacing: 0,
      centerTitle: true,
      title: isSearching
          ? TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: S.current.hintDefaultSearch,
                hintStyle: TextStyles.body1Regular(context)?.copyWith(
                  color: colors.onPrimary,
                ),
              ),
              style: TextStyles.body1Regular(context)?.copyWith(
                color: colors.onPrimary,
              ),
              autofocus: true,
              onChanged: (query) => onSearchQueryChanged?.call(query),
            )
          : Padding(
              padding: EdgeInsets.only(
                right: shouldShowBackIcon && actions.isEmpty ? 56 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: _getTitleLayout(context, colors)),
                  if (isCountRequired) _getCountLayout(context, colors),
                ],
              ),
            ),
      actions: [
        if (actions.isNotEmpty) ...actions,
      ],
    );
  }

  Widget _getTitleLayout(BuildContext context, ColorScheme theme) {
    return Text(
      title ?? S.current.titleApp,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.h5(context)?.copyWith(
        fontWeight: FontWeight.w500,
        color: theme.onPrimary,
      ),
    );
  }

  Widget _getCountLayout(BuildContext context, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.only(left: Units.kStandardPadding),
      child: Material(
        type: MaterialType.circle,
        color: theme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(Units.kSPadding),
          child: Center(
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyles.bodyRegular(context)?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
