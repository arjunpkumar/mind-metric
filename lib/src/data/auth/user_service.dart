import 'package:mind_metric/src/data/core/config_repository.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';
import 'package:mind_metric/src/utils/extensions.dart';
import 'package:mind_metric/src/utils/string_utils.dart';

class UserService {
  final ConfigRepository configRepository;

  UserService({required this.configRepository});

  Future<Map<String, dynamic>> fetchUser(AuthToken authToken) async {
    return {};
    /*try {
      final response = await NetworkClient.dioInstance.get(
        Config.appFlavor.restBaseUrlHeads +
            configRepository.restEmployeeBasicDetailsUrl,
        options: Options(headers: getHeaders(authToken)),
      );
      final responseMap = toGenericMap(response.data);
      if (responseMap["responseCode"] == 200) {
        return toGenericMap(responseMap["data"]);
      } else {
        throw CustomException(
          'ERROR FETCHING USER',
          message: responseMap['message'].toString(),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw CustomException('ERROR FETCHING USER', message: e.toString());
    }*/
  }
}

class UserMapper {
  User fromNetworkJson(Map<String, dynamic> json) {
    return User(
      id: toDefaultString(json["sub"]),
      firstName: toDefaultString(json["first_name"]),
      lastName: toDefaultString(json["last_name"]),
      designation: toString(json["designation"]),
      email: toString(json["email"]),
    );
  }

  /// Maps [Auth/Login] API `data` payload. [id] is stored as a string so quiz
  /// submit can use `int.tryParse(user.id)`.
  User fromAuthLoginData(
    Map<String, dynamic> json, {
    required String fallbackEmail,
  }) {
    final uid = _loginResponseUserId(json) ?? _deepFindUserIdForLogin(json);
    if (uid == null) {
      throw Exception(
        'Login response did not include a numeric user id '
        '(expected userId, id, or nested user.id).',
      );
    }

    Map<String, dynamic>? nested;
    final u = json['user'] ?? json['User'] ?? json['userDto'];
    if (u is Map<String, dynamic>) {
      nested = u;
    }

    String pick(String camel, String snake) {
      return toDefaultString(
        json[camel] ?? nested?[camel] ?? json[snake] ?? nested?[snake],
      );
    }

    final emailRaw = json['email'] ?? nested?['email'];
    final emailVal = toString(emailRaw);
    final email = StringUtils.isNotNullAndEmpty(emailVal)
        ? emailVal!
        : fallbackEmail;

    return User(
      id: uid.toString(),
      firstName: pick('firstName', 'first_name'),
      lastName: pick('lastName', 'last_name'),
      designation: toString(json['designation'] ?? nested?['designation']),
      email: email,
    );
  }
}

int? _parseIntDynamic(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v.trim());
  return null;
}

int? _loginResponseUserId(Map<String, dynamic> json) {
  for (final key in [
    'userId',
    'UserId',
    'user_id',
    'userID',
    'userid',
    'id',
    'ID',
  ]) {
    final i = _parseIntDynamic(json[key]);
    if (i != null) return i;
  }

  for (final nest in [
    'user',
    'User',
    'userDto',
    'UserDto',
    'data',
    'Data',
    'result',
    'Result',
  ]) {
    final v = json[nest];
    if (v is Map) {
      final i = _loginResponseUserId(Map<String, dynamic>.from(v));
      if (i != null) return i;
    }
  }
  return null;
}

/// Finds a user id when the API nests it under uncommon keys (avoids generic `id` deep scan).
int? _deepFindUserIdForLogin(dynamic node, [int depth = 0]) {
  if (depth > 10) return null;
  if (node is Map) {
    final m = Map<String, dynamic>.from(node);
    for (final key in const [
      'userId',
      'UserId',
      'user_id',
      'UserID',
      'userid',
    ]) {
      final i = _parseIntDynamic(m[key]);
      if (i != null) return i;
    }
    for (final v in m.values) {
      final nested = _deepFindUserIdForLogin(v, depth + 1);
      if (nested != null) return nested;
    }
  } else if (node is List) {
    for (final e in node) {
      final nested = _deepFindUserIdForLogin(e, depth + 1);
      if (nested != null) return nested;
    }
  }
  return null;
}

bool getBool(String value) {
  return value.toLowerCase() == "true";
}
