import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';
import 'package:mind_metric/src/presentation/auth/login/login_page.dart';
import 'package:mind_metric/src/presentation/quiz/qualification_quiz_models.dart';
import 'package:mind_metric/src/presentation/quiz/quiz_success_page.dart';
import 'package:mind_metric/src/presentation/quiz/quiz_time_expired_page.dart';

/// Matches [LandingPage] gradient for brand consistency.
const Color _kLandingBgTop = Color(0xFF0D1230);
const Color _kLandingBgMid = Color(0xFF101438);
const Color _kLandingBgBottom = Color(0xFF151B4A);
const Color _kLandingMuted = Color(0xFFA9AEC1);

const Color _kQuizBg = Color(0xFF0A0E21);
const Color _kPurple = Color(0xFF6A5ACD);

/// Timer bar fill while plenty of time remains (>10s).
const Color _kTimerBarGreen = Color(0xFF43A047);
const int _kSecondsPerQuestion = 30;

/// At or below this many seconds left, timer bar uses [AccountThemeColors.accent].
const int _kTimerBarAccentThresholdSeconds = 10;

/// Qualification flow: five timed multiple-choice questions.
class QualificationQuizPage extends StatefulWidget {
  const QualificationQuizPage({super.key});

  static const route = '/qualification-quiz';

  @override
  State<QualificationQuizPage> createState() => _QualificationQuizPageState();
}

class _QualificationQuizPageState extends State<QualificationQuizPage> {
  int _questionIndex = 0;
  int? _selectedOptionIndex;
  int _correctCount = 0;
  int _secondsLeft = _kSecondsPerQuestion;
  Timer? _timer;
  bool _timedOut = false;

  QualificationQuestion get _question =>
      kQualificationQuestions[_questionIndex];

  int get _totalQuestions => kQualificationQuestions.length;

  @override
  void initState() {
    super.initState();
    _startQuestionTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startQuestionTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _kSecondsPerQuestion;
      _timedOut = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        _timer?.cancel();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => QualificationQuizResultPage(
              correctAnswers: _correctCount,
              totalQuestions: _totalQuestions,
              timedOut: true,
              answeredAll: false,
            ),
          ),
        );
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onNext() {
    if (_timedOut || _selectedOptionIndex == null) return;

    final ok = _selectedOptionIndex == _question.correctOptionIndex;
    if (!ok) {
      _timer?.cancel();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => const QuizIncorrectAnswerPage(),
        ),
      );
      return;
    }

    _correctCount++;

    if (_questionIndex >= _totalQuestions - 1) {
      _timer?.cancel();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => const QuizSuccessPage(),
        ),
      );
      return;
    }

    setState(() {
      _questionIndex++;
      _selectedOptionIndex = null;
    });
    _startQuestionTimer();
  }

  @override
  Widget build(BuildContext context) {
    final questionProgress = (_questionIndex + 1) / _totalQuestions;
    final timerBarFillColor = _secondsLeft > _kTimerBarAccentThresholdSeconds
        ? _kTimerBarGreen
        : AccountThemeColors.accent;
    final letters = ['A', 'B', 'C', 'D'];
    final canProceed = _selectedOptionIndex != null && !_timedOut;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _kQuizBg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        _timer?.cancel();
                        Navigator.of(context).maybePop();
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Qualification Quiz',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Question ${_questionIndex + 1} of $_totalQuestions · '
                            '100% pass required',
                            style: TextStyle(
                              color: AccountThemeColors.muted.withValues(
                                alpha: 0.95,
                              ),
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: questionProgress,
                              minHeight: 8,
                              backgroundColor: AccountThemeColors.accent
                                  .withValues(alpha: 0.25),
                              color: _kPurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (_secondsLeft / _kSecondsPerQuestion)
                                  .clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.1,
                              ),
                              color: timerBarFillColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: _secondsLeft <= 5
                                ? Colors.redAccent
                                : Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$_secondsLeft',
                            style: TextStyle(
                              color: _secondsLeft <= 5
                                  ? Colors.redAccent
                                  : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          Text(
                            ' sec',
                            style: TextStyle(
                              color: (_secondsLeft <= 5
                                      ? Colors.redAccent
                                      : Colors.white)
                                  .withValues(alpha: 0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _kPurple.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _kPurple.withValues(alpha: 0.6),
                              ),
                            ),
                            child: const Text(
                              'MULTIPLE CHOICE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: AccountThemeColors.muted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Session monitored',
                            style: TextStyle(
                              color: AccountThemeColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _question.prompt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 22),
                      for (var i = 0; i < _question.options.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AnswerOptionTile(
                            letter: letters[i],
                            label: _question.options[i],
                            selected: _selectedOptionIndex == i,
                            enabled: !_timedOut,
                            onTap: () {
                              if (_timedOut) return;
                              setState(() => _selectedOptionIndex = i);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Column(
                  children: [
                    Text(
                      _timedOut
                          ? "Time's up for this question."
                          : 'Select an answer to continue',
                      style: TextStyle(
                        color: AccountThemeColors.muted.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: canProceed ? 1 : 0.45,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              AccountThemeColors.gradientStart,
                              AccountThemeColors.accent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AccountThemeColors.accent.withValues(
                                alpha: 0.45,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: canProceed ? _onNext : null,
                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'Next Question →',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color:
                              AccountThemeColors.muted.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Anti-cheat monitoring active · Do not navigate away',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AccountThemeColors.muted.withValues(
                                alpha: 0.65,
                              ),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Next Question checks your answer; wrong ends the attempt.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AccountThemeColors.muted.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pure skill. One prize. One winner.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AccountThemeColors.muted.withValues(alpha: 0.55),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerOptionTile extends StatelessWidget {
  const _AnswerOptionTile({
    required this.letter,
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String letter;
  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF12172E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AccountThemeColors.accent
                  : Colors.white.withValues(alpha: 0.1),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: AccountThemeColors.muted,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown after the last answer or when time runs out.
class QualificationQuizResultPage extends StatelessWidget {
  const QualificationQuizResultPage({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timedOut,
    required this.answeredAll,
  });

  final int correctAnswers;
  final int totalQuestions;
  final bool timedOut;
  final bool answeredAll;

  bool get _passed =>
      !timedOut && answeredAll && correctAnswers == totalQuestions;

  @override
  Widget build(BuildContext context) {
    if (timedOut) {
      return QuizTimeExpiredPage(
        onReturnToCompetitionHome: () => Navigator.of(context).pop(),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _kLandingBgTop,
                _kLandingBgMid,
                _kLandingBgBottom,
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Icon(
                    _passed
                        ? Icons.emoji_events_outlined
                        : Icons.fact_check_outlined,
                    size: 64,
                    color: _passed ? AccountThemeColors.accent : _kLandingMuted,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _passed ? 'Qualification passed' : 'Quiz complete',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You answered $correctAnswers of $totalQuestions '
                    'correctly. ${_passed ? 'You may proceed when the next step is available.' : '100% correct answers are required to pass.'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _kLandingMuted.withValues(alpha: 0.95),
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  const Spacer(),
                  _LandingStyleCtaButton(
                    label: 'BACK TO HOME',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrong answer ends the qualification attempt (matches competition UI spec).
class QuizIncorrectAnswerPage extends StatelessWidget {
  const QuizIncorrectAnswerPage({super.key});

  static const Color _coralTitle = Color(0xFFFF8A8A);
  static const Color lavenderBody = Color(0xFFB8B8D4);
  static const Color _redCircle = Color(0xFFD32F2F);
  static const Color _infoBoxBorder = Color(0xFF4A5BA8);
  static const Color _logOutBorder = Color(0xFFAB47BC);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _kLandingBgTop,
                _kLandingBgMid,
                _kLandingBgBottom,
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _redCircle,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _redCircle.withValues(alpha: 0.55),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 56,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Incorrect Answer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _coralTitle,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unfortunately, your last answer was incorrect.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: lavenderBody.withValues(alpha: 0.95),
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'A perfect score is required to proceed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2049),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _infoBoxBorder.withValues(alpha: 0.65),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'What happens next:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _IncorrectBullet(
                          text: 'Your current attempt has ended',
                        ),
                        const SizedBox(height: 10),
                        _IncorrectBullet(
                          text: 'You may purchase another entry to try again',
                        ),
                        const SizedBox(height: 10),
                        _IncorrectBullet(
                          text: 'Maximum 10 entries per competition',
                        ),
                        const SizedBox(height: 10),
                        _IncorrectBullet(
                          text:
                              'Log out and log back in to make payment for another attempt',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _LandingStyleCtaButton(
                    label: 'Return to Competition Home',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginPage.route,
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _coralTitle,
                      side: const BorderSide(
                        color: _logOutBorder,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pure skill. One prize. One winner.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _kLandingMuted.withValues(alpha: 0.65),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IncorrectBullet extends StatelessWidget {
  const _IncorrectBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AccountThemeColors.accent,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color:
                  QuizIncorrectAnswerPage.lavenderBody.withValues(alpha: 0.95),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _LandingStyleCtaButton extends StatelessWidget {
  const _LandingStyleCtaButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AccountThemeColors.gradientStart,
            AccountThemeColors.accent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AccountThemeColors.accent.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
