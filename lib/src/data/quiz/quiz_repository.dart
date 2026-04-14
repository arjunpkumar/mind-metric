import 'package:mind_metric/src/data/quiz/quiz_service.dart';
import 'package:mind_metric/src/presentation/quiz/qualification_quiz_models.dart';

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

class QuizRepository {
  QuizRepository(this.quizService);

  final QuizService quizService;

  Future<List<QualificationQuestion>> getRandomQuestions({
    required int userId,
  }) async {
    final rawData = await quizService.fetchRandomQuestions(userId: userId);

    final List<QualificationQuestion> questions = [];

    for (final rawQuestion in rawData) {
      final map = rawQuestion as Map<String, dynamic>;
      final text = map['text'] as String;
      final rawOptions = map['options'] as List<dynamic>;

      final questionId =
          _asInt(map['questionId']) ?? _asInt(map['id']);

      final choices = <QualificationAnswerChoice>[];
      var correctIndex = 0;

      for (var i = 0; i < rawOptions.length; i++) {
        final opt = rawOptions[i] as Map<String, dynamic>;
        final optionText = opt['text'] as String;
        final optionBackendId =
            _asInt(opt['selectedOptionId']) ??
                _asInt(opt['id']) ??
                _asInt(opt['optionId']);

        choices.add(
          QualificationAnswerChoice(
            text: optionText,
            backendId: optionBackendId,
          ),
        );

        if (opt['position'] == 1) {
          correctIndex = i;
        }
      }

      questions.add(
        QualificationQuestion(
          prompt: text,
          choices: choices,
          correctOptionIndex: correctIndex,
          questionId: questionId,
        ),
      );
    }

    return questions;
  }

  Future<void> submitAnswer({
    required int userId,
    required int questionId,
    required int selectedOptionId,
  }) {
    return quizService.submitAnswer(
      userId: userId,
      questionId: questionId,
      selectedOptionId: selectedOptionId,
    );
  }
}
