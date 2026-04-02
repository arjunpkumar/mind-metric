import 'package:flutter/material.dart';
import 'package:mind_metric/src/presentation/widgets/loader_widget.dart';

class LoaderUtil {
  static Future<void> showLoaderDialog(
    BuildContext context, {
    bool barrierDismissible = true,
  }) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return const LoaderWidget();
      },
    );
  }
}
