import 'dart:convert';

/// Reads a numeric user id from common JWT claims (OpenID / custom APIs).
int? quizUserIdFromIdToken(String? idToken) {
  if (idToken == null || idToken.isEmpty) return null;
  try {
    final parts = idToken.split('.');
    if (parts.length != 3) return null;
    final normalized = _base64UrlPadded(parts[1]);
    final map = json.decode(utf8.decode(base64.decode(normalized)))
        as Map<String, dynamic>;
    const keys = [
      'userId',
      'user_id',
      'UserId',
      'UserID',
      'userid',
      'employee_id',
      'employeeId',
      'id',
      'sub',
    ];
    for (final key in keys) {
      final v = _asInt(map[key]);
      if (v != null) return v;
    }
  } catch (_) {}
  return null;
}

String _base64UrlPadded(String input) {
  var s = input.replaceAll('-', '+').replaceAll('_', '/');
  final pad = s.length % 4;
  if (pad == 1) {
    s += '===';
  } else if (pad == 2) {
    s += '==';
  } else if (pad == 3) {
    s += '=';
  }
  return s;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}
