import 'package:flutter/material.dart';

/// Created by Jemsheer K D on 27 May, 2025.
/// File Name : app_material
/// Project : FlutterBase

class AppMaterial extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final MaterialType type;
  final double elevation;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final Clip clipBehavior;
  final Duration animationDuration;
  final double? height;
  final double? width;

  const AppMaterial({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.type = MaterialType.canvas,
    this.elevation = 0.0,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.textStyle,
    this.borderRadius,
    this.shape,
    this.borderOnForeground = true,
    this.clipBehavior = Clip.none,
    this.animationDuration = kThemeChangeDuration,
    this.height,
    this.width,
  })  : assert(elevation >= 0.0),
        assert(!(shape != null && borderRadius != null)),
        assert(
          !(identical(type, MaterialType.circle) &&
              (borderRadius != null || shape != null)),
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin != null ? margin! : EdgeInsets.zero,
      child: Material(
        key: key,
        type: type,
        elevation: elevation,
        color: color,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        textStyle: textStyle,
        borderRadius: borderRadius,
        shape: shape,
        borderOnForeground: borderOnForeground,
        clipBehavior: clipBehavior,
        animationDuration: animationDuration,
        child: (height != null || width != null)
            ? SizedBox(
                height: height,
                width: width,
                child: _getContentLayout(),
              )
            : _getContentLayout(),
      ),
    );
  }

  Widget? _getContentLayout() {
    return padding != null
        ? Padding(
            padding: padding!,
            child: child,
          )
        : child;
  }
}
