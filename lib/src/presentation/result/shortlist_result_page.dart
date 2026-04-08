import 'package:flutter/material.dart';
import 'package:mind_metric/src/presentation/dashboard/dashboard_page.dart';

const Color _kBgStart = Color(0xFF08002E);
const Color _kBgMid = Color(0xFF12006E);
const Color _kBgEnd = Color(0xFF1A0A7C);
const Color _kOrangeStart = Color(0xFFF59E0B);
const Color _kOrangeEnd = Color(0xFFEA580C);
const Color _kCardBg = Color(0x12FFFFFF); // ~rgba(255,255,255,.07)
const Color _kCardBorder = Color(0x1AFFFFFF); // ~rgba(255,255,255,.1)

class ShortlistResultPage extends StatelessWidget {
  const ShortlistResultPage({super.key});

  static const String route = '/shortlist-result';

  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      const _HeroSection(),
                      const SizedBox(height: 20),
                      const _InfoBar(),
                      const SizedBox(height: 14),
                      const _ScoreCard(),
                      const SizedBox(height: 14),
                      const _SubmissionCard(),
                      const SizedBox(height: 14),
                      const _NextStepsCard(),
                      const SizedBox(height: 14),
                      const _AuditTrailCard(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _GradientButton(
                          text: 'View All My Entries',
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              DashboardPage.route,
                              (route) => false,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Pure skill. One prize. One winner.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
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

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFF4ADE80).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: const Color(0xFF4ADE80).withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('⭐ ', style: TextStyle(fontSize: 12)),
                Text(
                  'Shortlisted — Top 300',
                  style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
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
              text: 'Your entry ranked in the ',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
                height: 1.65,
              ),
              children: const [
                TextSpan(
                  text: 'top 0.01%',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' of 387,241 entries.'),
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

class _ScoreCard extends StatelessWidget {
  const _ScoreCard();

  @override
  Widget build(BuildContext context) {
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
                          value: 0.94,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          color: const Color(0xFFF59E0B),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '94',
                            style: TextStyle(
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
                      const Text(
                        'Rank #47',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'of 387,241 entries',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ADE80).withValues(alpha: 0.12),
                          border: Border.all(
                            color: const Color(0xFF4ADE80)
                                .withValues(alpha: 0.25),
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('✅ ', style: TextStyle(fontSize: 11)),
                            Text(
                              'Proceeding to judging',
                              style: TextStyle(
                                color: Color(0xFF4ADE80),
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
              children: const [
                _RubricRow(
                  title: 'Relevance to the Prompt',
                  score: 96,
                  color: Color(0xFFF59E0B),
                ),
                _RubricRow(
                  title: 'Creativity & Originality',
                  score: 91,
                  color: Color(0xFF7C3AED),
                ),
                _RubricRow(
                  title: 'Clarity & Expression',
                  score: 94,
                  color: Color(0xFF3B82F6),
                ),
                _RubricRow(
                  title: 'Metaphorical Resonance',
                  score: 88,
                  color: Color(0xFFEA580C),
                ),
                _RubricRow(
                  title: 'Overall Impact',
                  score: 93,
                  color: Color(0xFF4ADE80),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
                Expanded(
                  flex: score,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Expanded(flex: 100 - score, child: const SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard();

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
                  '"In exactly 25 words, tell us why you should win this prize."',
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
            '"This beautiful BMW X5 would carry my young family across the country discovering small towns, sharing stories and creating memories together for many years."',
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
                '✅ 25 words',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '🔒 Locked 14 Mar 2026',
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
            text: '3 independent judges score your entry separately — no judge sees others\' scores',
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
  const _AuditTrailCard();

  @override
  Widget build(BuildContext context) {
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
            '🛡 Immutable Audit Trail',
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
          children: const [
            _AuditRow(
              event: 'Entry submitted & sealed',
              ts: '14 Mar 2026 09:42:17 UTC · Hash: a3f8d2c1…',
            ),
            _AuditRow(
              event: 'AI evaluation completed',
              ts: '14 Mar 2026 09:43:02 UTC · Hash: b9e1c7d3…',
            ),
            _AuditRow(
              event: 'Shortlist generated',
              ts: '15 Mar 2026 00:00:00 UTC · Hash: d4f2a1e8…',
            ),
            _AuditRow(
              event: 'Model: Lucid Engine AI™ v2.1.4',
              ts: 'Deterministic seed: 2026-Q1',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({
    required this.event,
    required this.ts,
    this.isLast = false,
  });

  final String event;
  final String ts;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            event,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            ts,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 11,
            ),
          ),
        ],
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
