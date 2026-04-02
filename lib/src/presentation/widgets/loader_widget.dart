import 'package:flutter/material.dart';
import 'package:mind_metric/src/core/app_constants.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        elevation: Units.kButtonElevation,
        child: Padding(
          padding: EdgeInsets.all(Units.kContentOffSet),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
