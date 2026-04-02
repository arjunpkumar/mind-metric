import 'package:flutter/material.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/utils/extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Created by Jemsheer K D on 11 March, 2025.
/// File Name : app_icon_widget
/// Project : FlutterBase

class AppIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;

  final VoidCallback? onTapCancel;
  final VoidCallback? onTapUp;
  final double iconSize;
  final double buttonSize;
  final String? iconPath;
  final IconData? icon;
  final Color? iconColor;
  final Color? buttonColor;
  final double elevation;
  final BorderSide? borderSide;
  final bool enabled;

  const AppIconButton({
    super.key,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.iconSize = Units.kAppIconSize,
    this.icon,
    this.iconPath,
    this.buttonSize = Units.kButtonHeight,
    this.iconColor,
    this.buttonColor,
    this.elevation = Units.kButtonElevation,
    this.borderSide,
    this.enabled = true,
  }) : assert(icon != null || iconPath != null);

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? Theme.of(context).colorScheme.onPrimary;
    return AbsorbPointer(
      absorbing: !enabled,
      child: Material(
        type: borderSide == null ? MaterialType.circle : MaterialType.canvas,
        color: buttonColor ?? Theme.of(context).colorScheme.primary,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: borderSide != null
            ? CircleBorder(side: borderSide!, eccentricity: 1)
            : null,
        elevation: elevation,
        child: InkWell(
          onTap: onTap,
          onTapDown: (_) => onTapDown?.call(),
          onTapUp: (_) => onTapUp?.call(),
          onTapCancel: () => onTapCancel?.call(),
          child: SizedBox(
            height: buttonSize,
            width: buttonSize,
            child: Center(
              child: iconPath != null
                  ? SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: SvgPicture.asset(
                        iconPath!,
                        height: iconSize,
                        width: iconSize,
                        colorFilter: color.toColorFilter(),
                      ),
                    )
                  : Icon(
                      icon,
                      size: iconSize,
                      color: color,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
