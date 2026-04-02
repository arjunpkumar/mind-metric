import 'package:flutter/material.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/presentation/core/theme/text_styles.dart';

class AppButton extends StatelessWidget {
  final Widget? child;
  final String? label;
  final TextStyle? labelStyle;
  final EdgeInsets? labelPadding;
  final VoidCallback onTap;
  final Color? color;
  final Color? disabledColor;
  final Color? labelColor;
  final Color? disabledLabelColor;
  final double elevation;
  final double height;
  final BorderRadius? borderRadius;
  final BorderSide borderSide;
  final FocusNode? focusNode;

  final bool enabled;

  const AppButton({
    super.key,
    this.child,
    this.label,
    this.labelStyle,
    required this.onTap,
    this.color,
    this.disabledColor,
    this.labelColor,
    this.disabledLabelColor,
    this.elevation = 0,
    this.height = Units.kButtonHeight,
    this.labelPadding,
    this.borderRadius,
    this.focusNode,
    this.enabled = true,
    this.borderSide = BorderSide.none,
  }) : assert(child != null || label != null);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: SizedBox(
        height: height,
        child: Material(
          color: enabled
              ? color ?? Theme.of(context).colorScheme.secondary
              : disabledColor ?? Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            side: borderSide,
            borderRadius: borderRadius ??
                BorderRadius.circular(Units.kButtonBorderRadius),
          ),
          child: InkWell(
            focusNode: focusNode,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              onTap();
            },
            child: _getContentLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _getContentLayout(BuildContext context) {
    return child ??
        Padding(
          padding: labelPadding ??
              const EdgeInsets.symmetric(
                vertical: Units.kSPadding,
                horizontal: Units.kStandardPadding,
              ),
          child: Center(
            child: Text(
              label ?? '',
              style: labelStyle ??
                  TextStyles.buttonSemiBold(context)?.copyWith(
                    color: enabled
                        ? labelColor ??
                            Theme.of(context).colorScheme.onSecondary
                        : disabledLabelColor ??
                            Theme.of(context).colorScheme.onPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        );
  }
}
