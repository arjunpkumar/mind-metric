import 'package:flutter/material.dart';
import 'package:mind_metric/src/presentation/core/theme/colors.dart';
import 'package:mind_metric/src/presentation/core/theme/text_styles.dart';
import 'package:mind_metric/src/utils/extensions.dart';

ThemeData getAppThemeData(BuildContext context) {
  return Theme.of(context).copyWith(
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryDark,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
    ),
    buttonTheme: ButtonTheme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
    ),
    textSelectionTheme:
        TextSelectionTheme.of(context).copyWith(cursorColor: AppColors.accent),
    scaffoldBackgroundColor: AppColors.softPeach,
    dividerColor: AppColors.chetWodeBlue,
    iconTheme: Theme.of(context).iconTheme.copyWith(color: AppColors.primary),
    checkboxTheme: CheckboxThemeData(
      fillColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.primary.setOpacity(.5);
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.primary.setOpacity(.5);
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.primary.setOpacity(.5);
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
      trackColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.primary.setOpacity(.5);
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
    ),
  );
}

ThemeData getMarkdownTheme(BuildContext context, {double fontDelta = 0}) {
  return Theme.of(context).copyWith(
    textTheme: Theme.of(context).textTheme.copyWith(
          headlineSmall: TextStyles.h2Light(context, fontDelta: fontDelta)
              ?.copyWith(fontWeight: FontWeight.w700),
          titleLarge: TextStyles.titleSemiBold(context, fontDelta: fontDelta),
          titleMedium: TextStyles.title2Medium(context, fontDelta: fontDelta),
          bodyLarge:
              TextStyles.body1BoldMarkdown(context, fontDelta: fontDelta),
          bodyMedium:
              TextStyles.body1RegularMarkdown(context, fontDelta: fontDelta),
        ),
  );
}

class AppTheme extends StatelessWidget {
  final Widget child;

  const AppTheme({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getAppThemeData(context),
      child: child,
    );
  }
}
