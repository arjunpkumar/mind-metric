import 'package:mind_metric/src/data/quiz/quiz_service.dart';
import 'package:mind_metric/src/presentation/quiz/qualification_quiz_models.dart';

/// One row from [GET /api/MyEntries/Shortlisted].
class ShortlistedListEntry {
  const ShortlistedListEntry({
    required this.entryId,
    this.createdAt,
  });

  final String entryId;
  final String? createdAt;

  factory ShortlistedListEntry.fromJson(Map<String, dynamic> json) {
    final id = (json['entry_id'] ?? json['entryId'] ?? json['EntryId'] ?? '')
        .toString()
        .trim();
    final created = json['created_at']?.toString() ??
        json['createdAt']?.toString();
    return ShortlistedListEntry(entryId: id, createdAt: created);
  }
}

/// One row from [GET /api/MyEntries/GetAllMyEntries].
class MyEntryListItem {
  const MyEntryListItem({
    required this.entryId,
    required this.userText,
    this.createdAt,
    this.status,
    this.context,
  });

  final String entryId;
  final String userText;
  final String? createdAt;
  final String? status;
  final String? context;

  factory MyEntryListItem.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ??
            json['entry_id'] ??
            json['entryId'] ??
            json['EntryId'] ??
            '')
        .toString()
        .trim();
    final text =
        (json['user_text'] ?? json['userText'] ?? '').toString();
    final created = json['created_at']?.toString() ??
        json['createdAt']?.toString();
    final status = json['status']?.toString();
    final context = json['context']?.toString();
    return MyEntryListItem(
      entryId: id,
      userText: text,
      createdAt: created,
      status: status,
      context: context,
    );
  }
}

/// One rubric line from [GET /api/MyEntries/Details] `sentiment_analysis.scores`.
class MyEntryRubricItem {
  const MyEntryRubricItem({required this.label, required this.score});

  final String label;
  final int score;
}

/// Parsed [GET /api/MyEntries/Details] response (Lucid Engine sentiment payload).
class MyEntryDetails {
  const MyEntryDetails({
    required this.userText,
    required this.entryId,
    required this.finalSentiment,
    required this.totalScore,
    required this.rubricItems,
    this.auditTrail,
    this.breakdownByKey = const {},
  });

  final String userText;
  final String entryId;
  final String finalSentiment;
  final int totalScore;
  final List<MyEntryRubricItem> rubricItems;
  final String? auditTrail;
  /// API `breakdown` map: snake_case key → narrative (optional).
  final Map<String, String> breakdownByKey;

  bool get isPositiveSentiment =>
      finalSentiment.toUpperCase() == 'POSITIVE';

  factory MyEntryDetails.fromDetailsApiJson(Map<String, dynamic> json) {
    final userText =
        (json['user_text'] ?? json['userText'] ?? '').toString().trim();
    final rawSa = json['sentiment_analysis'] ?? json['sentimentAnalysis'];
    final sa = rawSa is Map
        ? Map<String, dynamic>.from(rawSa)
        : <String, dynamic>{};

    final entryId =
        (sa['entry_id'] ?? sa['entryId'] ?? '').toString().trim();
    final finalSentiment =
        (sa['final_sentiment'] ?? sa['finalSentiment'] ?? '')
            .toString()
            .trim();

    final rawScores = sa['scores'];
    final scores = rawScores is Map
        ? Map<String, dynamic>.from(rawScores)
        : <String, dynamic>{};

    final total = _asInt(scores['total_score']) ??
        _asInt(scores['totalScore']) ??
        0;

    const orderedKeys = <String, String>{
      'relevance': 'Relevance to the Prompt',
      'creativity': 'Creativity & Originality',
      'clarity': 'Clarity & Expression',
      'metaphorical_resonance': 'Metaphorical Resonance',
      'overall_impact': 'Overall Impact',
    };

    final rubricItems = <MyEntryRubricItem>[];
    for (final e in orderedKeys.entries) {
      final n = _asInt(scores[e.key]);
      if (n != null) {
        rubricItems.add(MyEntryRubricItem(label: e.value, score: n));
      }
    }

    final breakdown = <String, String>{};
    final rawBd = sa['breakdown'];
    if (rawBd is Map) {
      for (final kv in rawBd.entries) {
        breakdown[kv.key.toString()] = kv.value?.toString() ?? '';
      }
    }

    final rawAudit =
        sa['audit_trail']?.toString() ?? sa['auditTrail']?.toString();
    final auditTrimmed = rawAudit?.trim();
    final auditTrail =
        auditTrimmed == null || auditTrimmed.isEmpty ? null : auditTrimmed;

    return MyEntryDetails(
      userText: userText,
      entryId: entryId.isNotEmpty ? entryId : '—',
      finalSentiment: finalSentiment.isNotEmpty ? finalSentiment : '—',
      totalScore: total.clamp(0, 100),
      rubricItems: rubricItems,
      auditTrail: auditTrail,
      breakdownByKey: breakdown,
    );
  }
}

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

  Future<List<ShortlistedListEntry>> getShortlistedEntries({
    required int userId,
  }) async {
    final raw = await quizService.fetchShortlistedEntries(userId: userId);
    return raw
        .map(ShortlistedListEntry.fromJson)
        .where((e) => e.entryId.isNotEmpty)
        .toList();
  }

  Future<int> getShortlistedCount({required int userId}) async {
    final entries = await getShortlistedEntries(userId: userId);
    return entries.length;
  }

  Future<List<MyEntryListItem>> getAllMyEntries({required int userId}) async {
    final raw = await quizService.fetchAllMyEntries(userId: userId);
    return raw
        .map(MyEntryListItem.fromJson)
        .where((e) => e.entryId.isNotEmpty)
        .toList();
  }

  Future<MyEntryDetails> getMyEntryDetails({
    required int userId,
    required String entryId,
  }) async {
    final raw = await quizService.fetchMyEntryDetails(
      userId: userId,
      entryId: entryId,
    );
    return MyEntryDetails.fromDetailsApiJson(raw);
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
