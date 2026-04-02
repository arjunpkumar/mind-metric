import 'package:flutter/material.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/presentation/widgets/app_button.dart';
import 'package:mind_metric/src/utils/string_utils.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? retryLabel;
  final VoidCallback retryOnTap;

  const ErrorMessageWidget({
    super.key,
    this.title,
    this.description,
    this.retryLabel,
    required this.retryOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? S.current.labelSomethingWentWrong,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (StringUtils.isNotNullAndEmpty(description))
              Padding(
                padding: const EdgeInsets.only(top: Units.kStandardPadding),
                child: Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Container(
              padding: const EdgeInsets.only(top: Units.kXXXLPadding),
              width: 200,
              child: AppButton(
                onTap: retryOnTap,
                label: S.current.btnTryAgain,
                elevation: Units.kButtonElevation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
