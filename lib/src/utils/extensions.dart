import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mind_metric/config.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/utils/guard.dart';
import 'package:mind_metric/src/utils/regex_util.dart';
import 'package:mind_metric/src/utils/string_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:rxdart/rxdart.dart';

bool notNull(dynamic source) {
  return source != null;
}

String extractName(String? firstName, String? lastName) {
  return [firstName, lastName].where(notNull).join(" ");
}

String getInitials(List<String?>? inputs, {int? maxLength}) {
  if (inputs == null || inputs.isEmpty) {
    return '';
  }
  String initials = inputs
      .map((i) => i?.trim())
      .where((i) => StringUtils.isNotNullAndEmpty(i))
      .map((s) => s!.substring(0, 1))
      .join()
      .toUpperCase();
  if (maxLength != null && initials.length > maxLength) {
    initials = initials.substring(0, maxLength);
  }

  return initials;
}

class IndexWalker {
  dynamic value;

  IndexWalker(this.value);

  IndexWalker operator [](Object index) {
    if (value != null) {
      value = toGenericMap(value)[index];
    }
    return this;
  }
}

/// [inputFromDate]newly selected from date
/// [inputToDate]newly selected to date
/// [pastFromDate]already exited from date
/// [pastToDate]already existed to date
bool isDatesInRange({
  required DateTime inputFromDate,
  required DateTime inputToDate,
  required DateTime pastFromDate,
  required DateTime pastToDate,
}) {
  //for checking the input date is not in range with past dates
  final isInputFromDateInRange = isDateInRange(
    testDate: inputFromDate,
    fromDate: pastFromDate,
    toDate: pastToDate,
  );
  final isInputToDateInRange = isDateInRange(
    testDate: inputToDate,
    fromDate: pastFromDate,
    toDate: pastToDate,
  );

  //for checking the past date is not in range with input dates
  final isPastFromDateInRange = isDateInRange(
    testDate: pastFromDate,
    fromDate: inputFromDate,
    toDate: inputToDate,
  );
  final isPastToDateInRange = isDateInRange(
    testDate: pastToDate,
    fromDate: inputFromDate,
    toDate: inputToDate,
  );

  return isInputFromDateInRange ||
      isInputToDateInRange ||
      isPastFromDateInRange ||
      isPastToDateInRange;
}

bool isDateInRange({
  required DateTime testDate,
  required DateTime fromDate,
  required DateTime toDate,
}) {
  return isDateEqualsAfter(testDate, fromDate) &&
      isDateEqualsBefore(testDate, toDate);
}

bool isDateEqualsAfter(DateTime toCheck, DateTime forCheck) {
  return toCheck == forCheck || toCheck.isAfter(forCheck);
}

bool isDateEqualsBefore(DateTime toCheck, DateTime forCheck) {
  return toCheck == forCheck || toCheck.isBefore(forCheck);
}

DateTime? maxDate(List<DateTime?>? dates) {
  if (dates?.isEmpty ?? true) {
    return null;
  }
  return dates!.nonNulls.reduce(
    (DateTime curr, DateTime next) => next.isAfter(curr) ? next : curr,
  );
}

int dataLengthInBytes(dynamic data) {
  int bytes;
  if (data != null) {
    bytes = utf8.encode(data.toString()).length;
  } else {
    bytes = 0;
  }
  return bytes;
}

String formatBytes(double? bytes, {int precision = 2}) {
  if (bytes == null || bytes <= 0) {
    return "0 B";
  }

  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  final i = (math.log(bytes) / math.log(1024)).floor();
  final val = (bytes / math.pow(1024, i)).toStringAsFixed(precision);
  return '$val ${suffixes[i]}';
}

String? normalizeDate(String? dateString) {
  if (dateString != null) {
    return dateString.contains("T")
        ? dateString.contains("Z")
            ? dateString
            : "${dateString}Z"
        : "${dateString}T00:00:00Z";
  }
  return null;
}

String? formatDate(
  DateTime? dateTime, {
  String format = 'dd/MM/yyyy',
  bool toLocal = true,
}) {
  if (dateTime == null) {
    return null;
  }
  return toLocal
      ? DateFormat(format).format(dateTime.toLocal())
      : DateFormat(format).format(dateTime);
}

String? getTimeFormat(DateTime? dateTime, BuildContext? context) {
  return Guard.asNullable<String>(() {
    if (dateTime == null || context == null) {
      return null;
    }
    return TimeOfDay.fromDateTime(dateTime).format(context);
  });
}

String? durationInDaysHoursMinutes(DateTime? fromTime, DateTime? toTime) {
  if (fromTime == null || toTime == null) {
    return null;
  }
  final duration = toTime.difference(fromTime);
  return [
    if (duration.inDays > 0) "${duration.inDays}d",
    if (duration.inHours.remainder(24) > 0)
      "${duration.inHours.remainder(24)}h",
    if (duration.inMinutes.remainder(60) > 0)
      "${duration.inMinutes.remainder(60)}min",
  ].join(" ");
}

DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

Future<bool> isDeviceIOSSimulator() async {
  bool isSimulator = false;
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    final info = await DeviceInfoPlugin().iosInfo;
    isSimulator = !info.isPhysicalDevice;
  }
  return isSimulator;
}

Future<String> getOSType() async {
  if (kIsWeb) return "Web";

  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS => "iOS",
    TargetPlatform.android => "Android",
    TargetPlatform.fuchsia => "Fuchsia",
    TargetPlatform.linux => "Linux",
    TargetPlatform.macOS => "MacOS",
    TargetPlatform.windows => "Windows"
  };
}

String encodeToBase64(String string) {
  final bytes = utf8.encode(string);
  return base64.encode(bytes);
}

extension StringFormatting on String {
  String toCapitalized() {
    switch (length) {
      case 0:
        return this;
      case 1:
        return this[0].toUpperCase();
      default:
        return this[0].toUpperCase() + substring(1);
    }
  }

  String toPascalCase() {
    return split(" ")
        .map((word) => word.toCapitalized())
        .join(" ")
        .split("/")
        .map((word) => word.toCapitalized())
        .join("/");
  }

  String wrapImageBaseUrl() {
    if (startsWith('http')) return this;
    if (startsWith('/')) replaceFirst('/', '');
    // return '${Config.appFlavor.imageBaseUrl}/$this';
    return '${Config.appFlavor.restBaseUrl}/$this';
  }

  double toDouble() {
    return double.tryParse(this) ?? 0.0;
  }

  int toInt() {
    return int.tryParse(this) ?? 0;
  }

  String formatNumber() {
    return (toInt() < 10) ? "0$this" : this;
  }

  String addQueryParam(String key, dynamic value) {
    return "$this${contains('?') ? '&' : '?'}$key=$value";
  }

  bool startsAnyWith(List<String?>? patternList) {
    return patternList?.nonNulls.any((pattern) => startsWith(pattern)) ?? false;
  }

  bool operator >(String other) => compareTo(other) > 0;

  bool operator <(String other) => compareTo(other) < 0;

  bool operator >=(String other) => compareTo(other) >= 0;

  bool operator <=(String other) => compareTo(other) <= 0;
}

Map<String, dynamic> toGenericMap(dynamic map) {
  if (map == null || map is! Map) return {};
  return Map<String, dynamic>.from(map);
}

List toGenericList(dynamic list) {
  if (list == null || list is! List) return [];
  return List.from(list);
}

List<T> toList<T>(dynamic list) {
  if (list == null || list is! List) return <T>[];
  return List<T>.from(list);
}

List<Map<String, dynamic>> toGenericMapList(dynamic list) {
  if (list == null && list is! List) return <Map<String, dynamic>>[];
  return List<Map<String, dynamic>>.from(
    toGenericList(list).map((e) => toGenericMap(e)).toList(),
  );
}

DateTime toDefaultDateTime(dynamic date, {DateTime? defaultValue}) {
  if (date is! String?) return defaultValue ?? DateTime(1970);
  return DateTime.tryParse(date ?? '') ?? defaultValue ?? DateTime(1970);
}

DateTime? toDateTime(dynamic date) {
  if (date is! String?) return null;
  return DateTime.tryParse(date ?? '');
}

String? toString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

String toDefaultString(dynamic value, {String defaultValue = ""}) {
  if (value == null) return defaultValue;
  return value?.toString() ?? defaultValue;
}

int? toInt(dynamic value) {
  return value?.toString().toInt();
}

int toDefaultInt(dynamic value, {int defaultValue = 0}) {
  return value?.toString().toInt() ?? defaultValue;
}

double? toDouble(dynamic value) {
  return value?.toString().toDouble();
}

double toDefaultDouble(dynamic value, {double defaultValue = 0.0}) {
  return value?.toString().toDouble() ?? defaultValue;
}

bool? toBool(dynamic value) {
  if (value is! bool?) return null;
  return value;
}

bool toDefaultBool(dynamic value, {bool defaultValue = false}) {
  if (value is! bool) return defaultValue;
  return value;
}

RegExp toRegex(String regex) {
  return RegexUtil.toRegex(regex);
}

extension AmountFormat on double {
  String toInternationalNumberFormatStringAsFixed({
    String format = "#,###.00",
    int decimalDigits = 2,
  }) {
    return formatNumber(this, format, decimalDigits);
  }
}

extension ColorUtils on Color {
  ColorFilter toColorFilter({BlendMode? blendMode}) {
    return ColorFilter.mode(
      this,
      blendMode ?? BlendMode.srcIn,
    );
  }

  Color setOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }
}

extension DateTimeUtils on DateTime {
  String get iso8601DateString => formatDate(this, format: 'yyyy-MM-dd')!;

  String get dateStringDDMMMYYYY => formatDate(this, format: 'dd MMM yyyy')!;

  DateTime removeTime({bool toUtc = false}) =>
      toUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

  bool isSameDate(DateTime other) =>
      removeTime().difference(other.removeTime()) == Duration.zero;

  int differenceInMonths(DateTime? other) {
    if (other == null) return 0;
    if (isAfter(other)) {
      if (year > other.year) {
        if (day >= other.day) {
          return (12 + month) - other.month;
        } else {
          return (12 + month - 1) - other.month;
        }
      } else {
        if (day >= other.day) {
          return month - other.month;
        } else {
          return month - 1 - other.month;
        }
      }
    } else {
      return 0;
    }
  }
}

extension ListUtil on List {
  bool containsAny<T>(List<T> list) {
    for (final T element in this as List<T>) {
      if (list.contains(element)) return true;
    }
    return false;
  }

  bool isSame<T>(List<T> list) {
    if ((this as List<T>).length != list.length) return false;
    for (final T element in this as List<T>) {
      if (!list.contains(element)) return false;
    }
    return true;
  }
}

extension StreamUtil<T> on Stream<T> {
  Stream<S> mapWithDefault<S>(S Function(T event) convert, S value) {
    return map(convert).distinct().startWith(value);
  }
}

extension FlutterSecureStorageUtil on FlutterSecureStorage {
  Future<String?> checkAndRead(String key) async {
    if (await containsKey(key: key)) {
      return read(key: key);
    }
    return null;
  }

  Future<void> checkAndDelete(String key) async {
    if (await containsKey(key: key)) {
      return delete(key: key);
    }
  }
}

Value<T> toValue<T>(T value) {
  return Value(value);
}

void hideKeyboard(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

/*String convertDaysToMonthsAndDays(
  int dayCount,
  DateTime startDate,
  DateTime endDate,
) {
  if (dayCount == null || startDate == null || endDate == null) return null;
  int months;
  int days;
  final newStartDate = startDate.add(const Duration(days: -1));
  months = endDate.differenceInMonths(newStartDate);
  if (months > 0) {
    final tempDate = DateTime(
      newStartDate.year,
      newStartDate.month + months,
      newStartDate.day,
    );
    days = endDate.difference(tempDate).inDays;
    final String strMonth =
        "labelXMonth".plural(months, args: [months.toString()]);
    final String strDay = "labelXDay".plural(days, args: [days.toString()]);

    return days > 0 ? "$strMonth ${"andText".tr()} $strDay" : strMonth;
  } else {
    days = endDate.difference(newStartDate).inDays;
    return "labelXDay".plural(days, args: [days.toString()]);
  }
}*/

String formatNumber(double value, String format, int decimalValue) {
  final formatter = NumberFormat(format, 'en_us');
  final fixedAmountString = value.toStringAsFixed(decimalValue);
  if (value >= 1 || value <= -1) {
    return formatter.format(fixedAmountString.toDouble());
  }
  return fixedAmountString;
}

///converts bytes to KBs or MBs or GBs
extension SizeUnitsConversion on int {
  String convertSizeUnits() {
    if (this > gbInBytes) {
      return "${(this / gbInBytes).toInternationalNumberFormatStringAsFixed()} GB";
    } else if (this > mbInBytes) {
      return "${(this / mbInBytes).toInternationalNumberFormatStringAsFixed()} MB";
    } else if (this > kbInBytes) {
      return "${(this / kbInBytes).toInternationalNumberFormatStringAsFixed()} KB";
    } else {
      return "$this Bytes";
    }
  }
}

String getFileContentType(File file) {
  return lookupMimeType(file.path) ?? "text/plain";
}

bool isAPISuccess(Response response) {
  return toDefaultInt(response.statusCode) ~/ 200 == 1;
}
