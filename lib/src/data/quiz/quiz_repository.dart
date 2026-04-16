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

        final isMarkedCorrect = opt['isCorrect'] == true ||
            opt['IsCorrect'] == true ||
            opt['correct'] == true ||
            opt['isAnswer'] == true;
        if (isMarkedCorrect) {
          correctIndex = i;
        } else if (opt['position'] == 1) {
          // Some backends mark the keyed answer with position 1.
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

  /// Uses server response as source of truth (Random API often omits correct flags).
  Future<bool> submitAnswer({
    required int userId,
    required int questionId,
    required int selectedOptionId,
  }) async {
    final json = await quizService.submitAnswer(
      userId: userId,
      questionId: questionId,
      selectedOptionId: selectedOptionId,
    );
    return _submitResponseIndicatesCorrect(json);
  }

  Future<int> getTotalAttempts({required int userId}) {
    return quizService.fetchTotalAttempts(userId: userId);
  }

  Future<String?> submitCreativeEntry({
    required int userId,
    required String userText,
  }) async {
    final response = await quizService.submitCreativeEntry(
      userId: userId,
      userText: userText,
    );

    final succeeded = response['succeeded'];
    if (succeeded == false || succeeded == 'false') {
      throw Exception(
        response['message']?.toString() ?? 'Creative submission failed',
      );
    }

    final candidates = <dynamic>[
      response['entryReference'],
      response['entryRef'],
      response['reference'],
      response['entry_reference'],
      (response['data'] is Map)
          ? (response['data'] as Map<dynamic, dynamic>)['entryReference']
          : null,
      (response['data'] is Map)
          ? (response['data'] as Map<dynamic, dynamic>)['entryRef']
          : null,
      (response['data'] is Map)
          ? (response['data'] as Map<dynamic, dynamic>)['reference']
          : null,
    ];

    for (final value in candidates) {
      if (value == null) continue;
      final s = value.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return null;
  }
}

/// Interprets [POST /api/Question/Submit] JSON (observed: wrong → isGameOver true).
bool _submitResponseIndicatesCorrect(Map<String, dynamic> json) {
  final explicit = json['isCorrect'] ??
      json['IsCorrect'] ??
      json['correct'] ??
      json['Correct'];
  if (explicit == true || explicit == 'true') {
    return true;
  }
  if (explicit == false || explicit == 'false') {
    return false;
  }

  final msg = json['message']?.toString().toLowerCase() ?? '';
  if (msg.contains('wrong')) {
    return false;
  }
  if (msg.contains('correct')) {
    return true;
  }

  final gameOver = json['isGameOver'];
  if (gameOver == true) {
    return false;
  }
  if (gameOver == false) {
    return true;
  }

  // Unknown shape: do not assume wrong (avoid false failures).
  return true;
}
