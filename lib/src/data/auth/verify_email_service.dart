import 'package:dio/dio.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/utils/extensions.dart';

/// Calls backend endpoints to send and confirm email verification codes.
///
/// Expected responses: HTTP 2xx. If the body is a JSON map with
/// `success: false`, `responseCode != 200`, or `message`, this class throws
/// [Exception] with a parsed message.
class VerifyEmailService {
  VerifyEmailService({Dio? dio}) : _dio = dio ?? NetworkClient.dioInstance;

  final Dio _dio;

  Future<void> sendVerificationCode({required String email}) async {
    try {
      final response = await _dio.post<dynamic>(
        APIEndpoints.sendEmailVerificationUrl,
        data: <String, dynamic>{'email': email},
      );
      _ensureSuccess(response);
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e));
    }
  }

  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final dio = Dio();
      final response = await dio.post<dynamic>(
        'http://172.27.13.182:5062/api/Auth/ValidateEmail',
        data: <String, dynamic>{
          'email': email,
          'otp': code,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Unable to verify OTP. Please try again.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          throw Exception(data['message'].toString());
        }
      }
      throw Exception('Unable to verify OTP. Please try again.');
    } catch (e) {
      throw Exception('Unable to verify OTP. Please try again.');
    }
  }

  Future<void> resendOTP({required String email}) async {
    try {
      final dio = Dio();
      final response = await dio.post<dynamic>(
        'http://172.27.13.182:5062/api/Auth/ResendOTP',
        data: '"$email"',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Unable to resend OTP. Please try again.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          throw Exception(data['message'].toString());
        }
      }
      throw Exception('Unable to resend OTP. Please try again.');
    } catch (e) {
      throw Exception('Unable to resend OTP. Please try again.');
    }
  }

  void _ensureSuccess(Response<dynamic> response) {
    final code = response.statusCode;
    if (code == null || code < 200 || code >= 300) {
      throw Exception('Unexpected status $code');
    }
    final data = response.data;
    if (data == null) {
      return;
    }
    if (data is! Map) {
      return;
    }
    final map = toGenericMap(data);
    final success = map['success'];
    if (success == false) {
      throw Exception(
        map['message']?.toString() ?? 'Request was not successful',
      );
    }
    final rc = map['responseCode'] ?? map['statusCode'];
    if (rc != null && rc != 200) {
      throw Exception(
        map['message']?.toString() ?? 'Request failed',
      );
    }
  }

  String _dioErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final m = toGenericMap(data);
      final msg = m['message'] ?? m['error'] ?? m['detail'] ?? m['title'];
      if (msg != null) {
        return msg.toString();
      }
      final errors = m['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          return first.first.toString();
        }
      }
    }
    if (e.message != null && e.message!.isNotEmpty) {
      return e.message!;
    }
    return 'Network error';
  }
}
