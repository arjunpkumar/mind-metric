import 'package:flutter/material.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/presentation/core/theme/colors.dart';

class InfoFieldWidget extends StatelessWidget {
  final String fieldTitle;
  final String? fieldValue;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  final CrossAxisAlignment crossAxisAlignment;

  const InfoFieldWidget({
    required this.fieldTitle,
    this.fieldValue,
    this.titleStyle,
    this.valueStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        Text(
          fieldTitle,
          style: titleStyle ??
              Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.tundora,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
          textAlign: crossAxisAlignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
        ),
        const SizedBox(
          height: Units.kXSPadding,
        ),
        Text(
          fieldValue ?? '-',
          style: valueStyle ??
              Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.tundora,
                    height: 1.5,
                  ),
          textAlign: crossAxisAlignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
        ),
      ],
    );
  }
}
