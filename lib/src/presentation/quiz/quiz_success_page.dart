import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_metric/src/presentation/quiz/creative_submission_page.dart';

const Color _kQuizSuccessBg = Color(0xFF050530);
const Color _kSuccessGreen = Color(0xFF4ADE80);
const Color _kTimerGold = Color(0xFFFBBF24);
const Color _kPromptLabel = Color(0xFFB8A9E8);
const Color _kCardBg = Color(0xFF0E1040);
const Color _kFooterBar = Color(0xFF030328);
const Color _kCtaOrangeStart = Color(0xFFF97316);
const Color _kCtaOrangeEnd = Color(0xFFEA580C);

const String _kLogoUrl =
    'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';

/// Shown when the user passes every qualification question.
class QuizSuccessPage extends StatelessWidget {
  const QuizSuccessPage({super.key});

  static const route = '/quiz-success';

  static const String _defaultCreativePrompt =
      'In exactly 25 words, tell us why you should win this prize.';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _kQuizSuccessBg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: CachedNetworkImage(
                          imageUrl: _kLogoUrl,
                          height: 36,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => const SizedBox(
                            height: 36,
                            width: 120,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _kCtaOrangeStart,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            color: _kSuccessGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _kSuccessGreen.withValues(alpha: 0.45),
                                blurRadius: 32,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 56,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A28),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _kSuccessGreen.withValues(alpha: 0.85),
                              width: 1.2,
                            ),
                          ),
                          child: const Text(
                            '🎓  Quiz Passed!',
                            style: TextStyle(
                              color: _kSuccessGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Quiz Successful!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Congratulations — you have passed the qualification '
                        'quiz. You may now submit your creative answer.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: _kCardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR PROMPT',
                              style: TextStyle(
                                color: _kPromptLabel.withValues(alpha: 0.95),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '“$_defaultCreativePrompt”',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.45,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              color: Colors.black.withValues(alpha: 0.35),
                              height: 1,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  color: _kTimerGold,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'You have 120 seconds to complete your submission',
                                    style: TextStyle(
                                      color: _kTimerGold.withValues(alpha: 0.98),
                                      fontSize: 14,
                                      height: 1.4,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [_kCtaOrangeStart, _kCtaOrangeEnd],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _kCtaOrangeStart.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push<void>(
                                MaterialPageRoute<void>(
                                  builder: (context) =>
                                      const CreativeSubmissionPage(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(28),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'Begin Creative Submission →',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Timer starts when you click above',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                14 + MediaQuery.of(context).padding.bottom,
              ),
              color: _kFooterBar,
              child: const Text(
                'Pure skill. One prize. One winner.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
