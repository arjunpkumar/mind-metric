import 'package:flutter/material.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/src/presentation/core/theme/text_styles.dart';
import 'package:flutter_base/src/presentation/widgets/dialog/app_dialog.dart';
import 'package:flutter_base/src/utils/string_utils.dart';
import 'package:tuple/tuple.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  void focusChange(
    BuildContext context,
    FocusNode? currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus?.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void showMessage(Tuple2<String, int> value) {
    if (StringUtils.isNotNullAndEmpty(value.item1) && mounted) {
      final colors = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value.item1,
            style: TextStyles.bodyRegular(context)!.copyWith(
              color: colors.onPrimary,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: value.item2),
          backgroundColor: colors.primary,
        ),
      );
    }
  }

  void showShortMessage(String value) {
    showMessage(Tuple2(value, 1));
  }

  void showMessageDialog(String value) {
    if (StringUtils.isNotNullAndEmpty(value) && mounted) {
      openAppDialog(
        context,
        title: value,
        positiveButtonText: S.current.btnOk.toUpperCase(),
      );
    }
  }
}
