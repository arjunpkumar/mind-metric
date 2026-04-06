/// One multiple-choice question in the qualification quiz.
class QualificationQuestion {
  const QualificationQuestion({
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
  });

  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
}

/// Five sample questions (100% pass required in UI copy).
const List<QualificationQuestion> kQualificationQuestions = [
  QualificationQuestion(
    prompt:
        'A business doubles its revenue each year. If it earns A\$12,500 in '
        'Year 1, in which year does it first exceed A\$100,000?',
    options: ['Year 3', 'Year 4', 'Year 5', 'Year 6'],
    correctOptionIndex: 2,
  ),
  QualificationQuestion(
    prompt: 'Which of these integers is a prime number?',
    options: ['4', '9', '17', '21'],
    correctOptionIndex: 2,
  ),
  QualificationQuestion(
    prompt: 'What is the capital city of Australia?',
    options: ['Sydney', 'Melbourne', 'Canberra', 'Perth'],
    correctOptionIndex: 2,
  ),
  QualificationQuestion(
    prompt: 'What is 15% of 200?',
    options: ['20', '25', '30', '35'],
    correctOptionIndex: 2,
  ),
  QualificationQuestion(
    prompt: 'What number comes next in the sequence: 2, 4, 8, 16, …?',
    options: ['24', '32', '64', '128'],
    correctOptionIndex: 1,
  ),
];
