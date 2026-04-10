import 'package:dio/dio.dart';

class AccountService {
  Future<void> register({
    required String email,
    required String password,
  }) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://172.27.13.182:5062/api/Auth/Register',
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Unable to create account. Please try again.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          throw Exception(data['message'].toString());
        }
      }
      throw Exception('Unable to create account. Please try again.');
    } catch (e) {
      throw Exception('Unable to create account. Please try again.');
    }
  }
}
