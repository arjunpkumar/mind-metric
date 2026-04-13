import 'package:dio/dio.dart';

class QuizService {
  Future<List<dynamic>> fetchRandomQuestions() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://172.27.13.182:5062/api/Question/Random');
      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }
}
