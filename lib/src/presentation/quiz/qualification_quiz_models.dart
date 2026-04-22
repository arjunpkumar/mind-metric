/// One selectable answer in a qualification question (UI label + optional API id).
class QualificationAnswerChoice {
  const QualificationAnswerChoice({
    required this.text,
    this.backendId,
  });

  final String text;
  final int? backendId;
}

/// One multiple-choice question in the qualification quiz.
class QualificationQuestion {
  const QualificationQuestion({
    required this.prompt,
    required this.choices,
    required this.correctOptionIndex,
    this.questionId,
  });

  final String prompt;
  final List<QualificationAnswerChoice> choices;
  final int correctOptionIndex;

  /// When set, answers can be posted to [POST /api/Question/Submit].
  final int? questionId;
}

/// Five sample questions (100% pass required in UI copy).
const List<QualificationQuestion> kQualificationQuestions = [
  QualificationQuestion(
    prompt:
        'A business doubles its revenue each year. If it earns A\$12,500 in '
        'Year 1, in which year does it first exceed A\$100,000?',
    choices: [
      QualificationAnswerChoice(text: 'Year 3'),
      QualificationAnswerChoice(text: 'Year 4'),
      QualificationAnswerChoice(text: 'Year 5'),
      QualificationAnswerChoice(text: 'Year 6'),
    ],
    correctOptionIndex: 2,
  ),
  QualificationQuestion(
    prompt: 'Which of these integers is a prime number?',
    choices: [
      QualificationAnswerChoice(text: '4'),
      QualificationAnswerChoice(text: '9'),
      QualificationAnswerChoice(text: '17'),
      QualificationAnswerChoice(text: '21'),
    ],
    correctOptionIndex: 2,
  ),
  QualificationQuestion(
    prompt: 'What is the capital city of Australia?',
    choices: [
      QualificationAnswerChoice(text: 'Sydney'),
      QualificationAnswerChoice(text: 'Melbourne'),
      QualificationAnswerChoice(text: 'Canberra'),
      QualificationAnswerChoice(text: 'Perth'),
    ],
    correctOptionIndex: 2,
  ),
  QualificationQuestion(
    prompt: 'What is 15% of 200?',
    choices: [
      QualificationAnswerChoice(text: '20'),
      QualificationAnswerChoice(text: '25'),
      QualificationAnswerChoice(text: '30'),
      QualificationAnswerChoice(text: '35'),
    ],
    correctOptionIndex: 2,
  ),
  QualificationQuestion(
    prompt: 'What number comes next in the sequence: 2, 4, 8, 16, …?',
    choices: [
      QualificationAnswerChoice(text: '24'),
      QualificationAnswerChoice(text: '32'),
      QualificationAnswerChoice(text: '64'),
      QualificationAnswerChoice(text: '128'),
    ],
    correctOptionIndex: 1,
  ),
];
