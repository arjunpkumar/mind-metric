import 'package:flutter/material.dart';

class TextStyles {
  TextStyles._();

  static const _kRoboto = "Roboto";

  static TextStyle? h1ExtraLight(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 50,
        fontWeight: FontWeight.w200,
        letterSpacing: -1.5,
      );

  static TextStyle? h2(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.84,
      );

  static TextStyle? h2ExtraLight(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 32,
        fontWeight: FontWeight.w200,
        letterSpacing: -0.72,
        height: 1.25,
      );

  static TextStyle? h2Light(BuildContext context, {double fontDelta = 0}) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 32.0 + fontDelta,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.72,
        height: 1.25,
      );

  static TextStyle? h2Bold(BuildContext context, {double fontDelta = 0}) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 32.0 + fontDelta,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.72,
        height: 1.25,
      );

  static TextStyle? h3Light(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 28,
        fontWeight: FontWeight.w200,
        letterSpacing: -0.84,
      );

  static TextStyle? h3Bold(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.5,
      );

  static TextStyle? h3(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.25,
      );

  static TextStyle? h4(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.25,
      );

  static TextStyle? h4Bold(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  static TextStyle? h5(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.72,
        height: 1.25,
      );

  static TextStyle? h5Bold(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.72,
        height: 1.25,
      );

  static TextStyle? h6(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.72,
        height: 1.25,
      );

  static TextStyle? h6Bold(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.72,
        height: 1.25,
      );

  static TextStyle? titleBold(
      BuildContext context, {
        double fontDelta = 0,
      }) =>
      Theme.of(context).textTheme.titleLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        height: 1.1,
      );

  static TextStyle? titleSemiBold(
      BuildContext context, {
        double fontDelta = 0,
      }) =>
      Theme.of(context).textTheme.titleLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 20.0 + fontDelta,
        fontWeight: FontWeight.w600,
        height: 1.1,
      );

  static TextStyle? title2Bold(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
      );

  static TextStyle? title2Medium(
      BuildContext context, {
        double fontDelta = 0,
      }) =>
      Theme.of(context).textTheme.titleLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 16.0 + fontDelta,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.25,
      );

  static TextStyle? title3Bold(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.23,
        height: 1.07,
      );

  static TextStyle? buttonBlack(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 14,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.23,
      );

  static TextStyle? buttonLight(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  static TextStyle? buttonNormal(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 10,
        fontWeight: FontWeight.w400,
      );

  static TextStyle? buttonSemiBold(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.23,
      );

  static TextStyle? body1Bold(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.23,
      );

  static TextStyle? body2Bold(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.23,
      );

  static TextStyle? body2Regular(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.2,
        height: 1.23,
      );

  static TextStyle? bodyRegular(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle? bodyBold(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  static TextStyle? body1BoldMarkdown(
      BuildContext context, {
        double fontDelta = 0,
      }) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 16.0 + fontDelta,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.5,
      );

  static TextStyle? body1Regular(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 14,
        letterSpacing: -0.2,
        height: 1.23,
      );

  static TextStyle? body1RegularMarkdown(
      BuildContext context, {
        double fontDelta = 0,
      }) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 16.0 + fontDelta,
        letterSpacing: -0.2,
        height: 1.23,
      );

  static TextStyle? captionBold(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      );

  static TextStyle? captionRegular(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 12,
      );

  static TextStyle? labelRegular(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: _kRoboto,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );
}
