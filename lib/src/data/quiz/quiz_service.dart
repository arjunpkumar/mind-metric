import 'package:dio/dio.dart';
import 'package:mind_metric/src/core/app_constants.dart';

class QuizService {
  QuizService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<dynamic>> fetchRandomQuestions({required int userId}) async {
    try {
      final response = await _dio.get(
        '$kMindMetricApiBaseUrl/api/Question/Random',
        queryParameters: <String, dynamic>{'userId': userId},
      );
      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  /// Returns how many quiz attempts the user has consumed (entries used).
  Future<int> fetchTotalAttempts({required int userId}) async {
    try {
      final response = await _dio.get(
        '$kMindMetricApiBaseUrl/api/Question/TotalAttempts',
        queryParameters: <String, dynamic>{'userId': userId},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to load entry count');
      }
      return _parseNumericBody(response.data);
    } catch (e) {
      throw Exception('Failed to load entry count: $e');
    }
  }

  /// Count of shortlisted entries from [GET /api/MyEntries/Shortlisted].
  Future<int> fetchShortlistedCount({required int userId}) async {
    try {
      final response = await _dio.get<dynamic>(
        '$kMindMetricApiBaseUrl/api/MyEntries/Shortlisted',
        queryParameters: <String, dynamic>{'userId': userId},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to load shortlisted count');
      }
      return _parseShortlistedCount(response.data);
    } catch (e) {
      throw Exception('Failed to load shortlisted count: $e');
    }
  }

  /// Returns parsed JSON body from a successful submit (used for correctness).
  Future<Map<String, dynamic>> submitAnswer({
    required int userId,
    required int questionId,
    required int selectedOptionId,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '$kMindMetricApiBaseUrl/api/Question/Submit',
        data: <String, dynamic>{
          'userId': userId,
          'questionId': questionId,
          'selectedOptionId': selectedOptionId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      final code = response.statusCode;
      if (code == null || code < 200 || code >= 300) {
        throw Exception('Submit failed (${code ?? 'unknown'})');
      }
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return <String, dynamic>{};
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message;
      throw Exception('Failed to submit answer: $msg');
    }
  }

  Future<Map<String, dynamic>> submitCreativeEntry({
    required int userId,
    required String userText,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '$kMindMetricApiBaseUrl/api/MyEntries/Evaluate',
        data: <String, dynamic>{
          'user_text': userText,
          'userId': userId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      final code = response.statusCode;
      if (code == null || code < 200 || code >= 300) {
        throw Exception('Creative submission failed (${code ?? 'unknown'})');
      }
      final data = response.data;
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return <String, dynamic>{'data': data};
    } on DioException catch (e) {
      final serverData = e.response?.data;
      if (serverData is Map) {
        final map = Map<String, dynamic>.from(serverData);
        final msg = map['message']?.toString();
        if (msg != null && msg.isNotEmpty) {
          throw Exception(msg);
        }
      }
      final msg = e.response?.data?.toString() ?? e.message;
      throw Exception('Creative submission failed: $msg');
    }
  }
}

int _parseNumericBody(dynamic data) {
  final direct = _tryParseIntLoose(data);
  if (direct != null) return direct;
  if (data is Map) {
    final m = Map<String, dynamic>.from(data);
    for (final k in [
      'data',
      'Data',
      'count',
      'value',
      'result',
      'totalAttempts',
    ]) {
      if (m.containsKey(k)) {
        final v = _tryParseIntLoose(m[k]);
        if (v != null) return v;
      }
    }
  }
  return 0;
}

int _parseShortlistedCount(dynamic data) {
  if (data is List) {
    return data.length;
  }
  final n = _tryParseIntLoose(data);
  if (n != null) {
    return n;
  }
  if (data is Map) {
    final m = Map<String, dynamic>.from(data);
    for (final k in ['data', 'Data', 'items', 'entries', 'results']) {
      final v = m[k];
      if (v is List) {
        return v.length;
      }
    }
  }
  return 0;
}

int? _tryParseIntLoose(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v.trim());
  return null;
}
