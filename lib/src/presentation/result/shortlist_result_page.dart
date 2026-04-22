import 'package:flutter/material.dart';
import 'package:mind_metric/src/data/core/repository_provider.dart';
import 'package:mind_metric/src/data/quiz/quiz_repository.dart';
import 'package:mind_metric/src/presentation/dashboard/dashboard_page.dart';
import 'package:mind_metric/src/presentation/quiz/creative_submission_page.dart';

const Color _kBgStart = Color(0xFF08002E);
const Color _kBgMid = Color(0xFF12006E);
const Color _kBgEnd = Color(0xFF1A0A7C);
const Color _kOrangeStart = Color(0xFFF59E0B);
const Color _kOrangeEnd = Color(0xFFEA580C);
const Color _kCardBg = Color(0x12FFFFFF); // ~rgba(255,255,255,.07)
const Color _kCardBorder = Color(0x1AFFFFFF); // ~rgba(255,255,255,.1)

/// Arguments for [ShortlistResultPage] (from dashboard shortlisted tile).
class ShortlistResultRouteArgs {
  const ShortlistResultRouteArgs({
    required this.userId,
    required this.entryId,
  });

  final int userId;
  final String entryId;
}

class ShortlistResultPage extends StatefulWidget {
  const ShortlistResultPage({super.key, this.routeArgs});

  static const String route = '/shortlist-result';

  final ShortlistResultRouteArgs? routeArgs;

  @override
  State<ShortlistResultPage> createState() => _ShortlistResultPageState();
}

class _ShortlistResultPageState extends State<ShortlistResultPage> {
  bool _loading = true;
  Object? _error;
  MyEntryDetails? _details;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final args = widget.routeArgs;
    if (args == null) {
      setState(() {
        _loading = false;
        _error = 'Missing entry. Open this screen from a shortlisted entry.';
        _details = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final d = await provideQuizRepository().getMyEntryDetails(
        userId: args.userId,
        entryId: args.entryId,
      );
      if (!mounted) return;
      setState(() {
        _details = d;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
        _details = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = _details;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_kBgStart, _kBgMid, _kBgEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF59E0B),
                        ),
                      )
                    : _error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _error.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.85),
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextButton(
                                    onPressed: _load,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : details == null
                            ? const SizedBox.shrink()
                            : SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Column(
                                  children: [
                                    _HeroSection(details: details),
                                    const SizedBox(height: 20),
                                    const _InfoBar(),
                                    const SizedBox(height: 14),
                                    _ScoreCard(details: details),
                                    const SizedBox(height: 14),
                                    _SubmissionCard(details: details),
                                    const SizedBox(height: 14),
                                    const _NextStepsCard(),
                                    const SizedBox(height: 14),
                                    _AuditTrailCard(details: details),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: _GradientButton(
                                        text: 'View All My Entries',
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            DashboardPage.route,
                                            (route) => false,
                                            arguments: const DashboardRouteArgs(
                                              initialTabIndex: 1,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      'Pure skill. One prize. One winner.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.45),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

int _wordCount(String text) {
  final t = text.trim();
  if (t.isEmpty) return 0;
  return t.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.details});

  final MyEntryDetails details;

  @override
  Widget build(BuildContext context) {
    final positive = details.isPositiveSentiment;
    final badgeColor = positive ? const Color(0xFF4ADE80) : const Color(0xFFF59E0B);
    final badgeBg = positive
        ? const Color(0xFF4ADE80).withValues(alpha: 0.15)
        : const Color(0xFFF59E0B).withValues(alpha: 0.15);
    final badgeBorder = positive
        ? const Color(0xFF4ADE80).withValues(alpha: 0.3)
        : const Color(0xFFF59E0B).withValues(alpha: 0.35);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF59E0B).withValues(alpha: 0.15),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_kOrangeStart, _kOrangeEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.45),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text('🏆', style: TextStyle(fontSize: 34)),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: badgeBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⭐ ', style: TextStyle(fontSize: 12)),
                Text(
                  'Shortlisted · ${details.finalSentiment}',
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            details.entryId,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Congratulations!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: 'Lucid Engine AI™ scored your entry ',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
                height: 1.65,
              ),
              children: [
                TextSpan(
                  text: '${details.totalScore}/100',
                  style: const TextStyle(
                    color: Color(0xFFF59E0B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: positive
                      ? ' — strong signal toward the shortlist.'
                      : ' — see rubric for detail.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                    height: 1.65,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoBar extends StatelessWidget {
  const _InfoBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x0FFFFFFF), // ~rgba(255,255,255,0.06)
        border: Border.all(color: _kCardBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: '🧠 Lucid Engine AI™',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const TextSpan(
              text: ' — structured deterministic evaluation engine, not generative AI. Scores against a fixed rubric. ',
            ),
            const TextSpan(
              text: 'Final winners confirmed exclusively by 3 independent human judges.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        style: TextStyle(
          fontSize: 13,
          color: const Color(0xFFB4D2FF).withValues(alpha: 0.8),
          height: 1.6,
        ),
      ),
    );
  }
}

const List<Color> _kRubricColors = [
  Color(0xFFF59E0B),
  Color(0xFF7C3AED),
  Color(0xFF3B82F6),
  Color(0xFFEA580C),
  Color(0xFF4ADE80),
];

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.details});

  final MyEntryDetails details;

  @override
  Widget build(BuildContext context) {
    final total = details.totalScore.clamp(0, 100);
    final progress = total / 100.0;
    final positive = details.isPositiveSentiment;
    final items = details.rubricItems;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _kCardBg,
        border: Border.all(color: _kCardBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AI Evaluation Score',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lucid Engine AI™',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          color: const Color(0xFFF59E0B),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$total',
                            style: const TextStyle(
                              color: Color(0xFFF59E0B),
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '/100',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total score',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${details.totalScore} / 100',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (positive
                                  ? const Color(0xFF4ADE80)
                                  : const Color(0xFFF59E0B))
                              .withValues(alpha: 0.12),
                          border: Border.all(
                            color: (positive
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFFF59E0B))
                                .withValues(alpha: 0.25),
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              positive ? '✅ ' : 'ℹ️ ',
                              style: const TextStyle(fontSize: 11),
                            ),
                            Text(
                              positive
                                  ? 'Sentiment: POSITIVE'
                                  : 'Sentiment: ${details.finalSentiment}',
                              style: TextStyle(
                                color: positive
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFFF59E0B),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              title: const Text(
                'View Rubric Breakdown',
                style: TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconColor: const Color(0xFFF59E0B),
              collapsedIconColor: const Color(0xFFF59E0B),
              tilePadding: const EdgeInsets.symmetric(horizontal: 14),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              children: [
                for (var i = 0; i < items.length; i++)
                  _RubricRow(
                    title: items[i].label,
                    score: items[i].score,
                    color: _kRubricColors[i % _kRubricColors.length],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RubricRow extends StatelessWidget {
  const _RubricRow({
    required this.title,
    required this.score,
    required this.color,
  });

  final String title;
  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final s = score.clamp(0, 100);
    final filled = s <= 0 ? 0 : s;
    final empty = 100 - filled;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$score',
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (filled > 0)
                  Expanded(
                    flex: filled,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                if (empty > 0)
                  Expanded(
                    flex: empty,
                    child: const SizedBox(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard({required this.details});

  final MyEntryDetails details;

  @override
  Widget build(BuildContext context) {
    final wc = _wordCount(details.userText);
    final response = details.userText.isEmpty ? '—' : details.userText;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCardBg,
        border: Border.all(color: _kCardBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Submission',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROMPT',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\u201C${CreativeSubmissionPage.prompt}\u201D",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                    height: 1.65,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'YOUR RESPONSE',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\u201C$response\u201D',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.65,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '✅ $wc words',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Entry ${details.entryId}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextStepsCard extends StatelessWidget {
  const _NextStepsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCardBg,
        border: Border.all(color: _kCardBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What Happens Next',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const _StepItem(
            numText: '1',
            text:
                "3 independent judges score your entry separately — no judge sees others' scores",
          ),
          const _StepItem(
            numText: '2',
            text: 'All judges complete evaluation before scores are aggregated',
          ),
          const _StepItem(
            numText: '3',
            text: 'Tied entries subject to secondary review and consensus',
          ),
          const _StepItem(
            numText: '4',
            text: 'Independent scrutineer verifies the process and confirms the final result',
          ),
          const _StepItem(
            numText: '5',
            text: 'Winners announced at competition close',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.numText,
    required this.text,
    this.isLast = false,
  });

  final String numText;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
              border: Border.all(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              numText,
              style: const TextStyle(
                color: Color(0xFFC4B5FD),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditTrailCard extends StatelessWidget {
  const _AuditTrailCard({required this.details});

  final MyEntryDetails details;

  @override
  Widget build(BuildContext context) {
    final audit = details.auditTrail;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _kCardBg,
        border: Border.all(color: _kCardBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: const Text(
            '🛡 Evaluation audit trail',
            style: TextStyle(
              color: Color(0xFFF59E0B),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconColor: const Color(0xFFF59E0B),
          collapsedIconColor: const Color(0xFFF59E0B),
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          children: [
            if (audit != null && audit.isNotEmpty)
              SelectableText(
                audit,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 12,
                  height: 1.55,
                ),
              )
            else
              Text(
                'No audit narrative returned for this entry.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kOrangeStart, _kOrangeEnd],
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEA580C).withValues(alpha: 0.4),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
