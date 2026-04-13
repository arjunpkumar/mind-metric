import 'package:mind_metric/src/data/quiz/quiz_service.dart';
import 'package:mind_metric/src/presentation/quiz/qualification_quiz_models.dart';

class QuizRepository {
  QuizRepository(this.quizService);

  final QuizService quizService;

  Future<List<QualificationQuestion>> getRandomQuestions() async {
    final rawData = await quizService.fetchRandomQuestions();
    
    final List<QualificationQuestion> questions = [];
    
    for (final rawQuestion in rawData) {
      final text = rawQuestion['text'] as String;
      final rawOptions = rawQuestion['options'] as List<dynamic>;
      
      final optionsText = <String>[];
      int correctIndex = 0;
      
      for (int i = 0; i < rawOptions.length; i++) {
        final opt = rawOptions[i];
        optionsText.add(opt['text'] as String);
        
        if (opt['position'] == 1) {
          correctIndex = i;
        }
      }
      
      questions.add(QualificationQuestion(
        prompt: text,
        options: optionsText,
        correctOptionIndex: correctIndex,
      ));
    }
    
    return questions;
  }
}
