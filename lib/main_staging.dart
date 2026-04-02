import 'dart:async';

import 'package:mind_metric/config.dart';
import 'package:mind_metric/src/core/app.dart';

Future<void> main() async {
  Config.appFlavor = Staging();
  await initApp();
}
