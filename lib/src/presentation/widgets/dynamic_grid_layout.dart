import 'package:flutter/material.dart';
import 'package:mind_metric/src/core/app_constants.dart';

class DynamicGridLayout extends StatelessWidget {
  final List<Widget> list;
  final int minItemWidth;
  final double columnPadding;
  final Widget columnDivider;
  final Widget rowDivider;

  const DynamicGridLayout({
    required this.list,
    required this.minItemWidth,
    required this.columnPadding,
    required this.columnDivider,
    required this.rowDivider,
  });

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;
    final int columnCount = displayWidth ~/ (minItemWidth + columnPadding);

    final reminder = list.length.remainder(columnCount);
    final dividend = list.length ~/ columnCount;
    final rowCount = reminder == 0 ? dividend : dividend + 1;
    return ListView.separated(
      padding: const EdgeInsets.only(top: Units.kSPadding),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final cursor = index * columnCount;

        if (index + 1 == rowCount && reminder != 0) {
          final length = (reminder * 2) + 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              length,
              (colIndex) => colIndex.isEven
                  ? Expanded(
                      flex: colIndex + 1 == length ? columnCount - reminder : 1,
                      child: colIndex + 1 == length
                          ? Container()
                          : list[cursor + colIndex ~/ 2],
                    )
                  : colIndex == length - 2
                      ? SizedBox(
                          width:
                              (Units.kSPadding + 2) * (columnCount - reminder),
                        )
                      : columnDivider,
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            (columnCount * 2) - 1,
            (colIndex) => colIndex.isEven
                ? Expanded(child: list[cursor + colIndex ~/ 2])
                : columnDivider,
          ),
        );
      },
      separatorBuilder: (context, index) => rowDivider,
      itemCount: rowCount,
    );
  }
}
