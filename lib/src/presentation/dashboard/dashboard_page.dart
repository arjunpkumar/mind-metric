import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_metric/src/data/core/repository_provider.dart';
import 'package:mind_metric/src/presentation/payment/payment_page.dart';
import 'package:mind_metric/src/presentation/quiz/qualification_quiz_page.dart';
import 'package:mind_metric/src/presentation/result/shortlist_result_page.dart';

const Color _kBg = Color(0xFF0B0B2E);
const Color _kCardBg = Color(0xFF12143A);
const Color _kCardBorder = Color(0xFF2A2D5C);
const Color _kMuted = Color(0xFF9CA3C7);
const Color _kMutedPurple = Color(0xFFB8A9E8);
const Color _kOrange = Color(0xFFFF8C00);
const Color _kOrangeDeep = Color(0xFFFF6B00);
const Color _kOrangeGlow = Color(0x40FF8C00);
const Color _kNavBg = Color(0xFF070720);
const Color _kActiveTabLabel = Color(0xFFFFE066);
const Color _kShortlistGreen = Color(0xFF1DE9B6);
const Color _kShortlistCardBorder = Color(0xFF5B4D8C);
const Color _kTimerBoxBg = Color(0xFF16184A);
const Color _kFooterTagline = Color(0xFF6B7199);

const String _kLogoUrl =
    'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';

/// Fixed end time for the competition countdown (demo).
final DateTime _kCompetitionEndUtc = DateTime.utc(2026, 7, 2, 14, 22, 26);

/// Total qualification entry slots per user (matches API / product rules).
const _kEntriesMax = 10;
const _kShortlistedStat = 1;

class DashboardRouteArgs {
  const DashboardRouteArgs({
    this.userName = 'Jordan Davies',
    this.shortlistedEntryRef = 'TBSC-2026-004521',
  });

  final String userName;
  final String shortlistedEntryRef;
}

/// Main competition dashboard with bottom navigation (matches product mock).
class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    this.userName = 'Jordan Davies',
    this.shortlistedEntryRef = 'TBSC-2026-004521',
  });

  static const route = '/dashboard';

  final String userName;
  final String shortlistedEntryRef;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _tabIndex = 0;
  Timer? _tick;
  Duration _remaining = Duration.zero;

  /// From [GET /api/Question/TotalAttempts]. `null` if still loading or unavailable.
  int? _entriesUsed;
  bool _entriesLoading = true;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_updateRemaining);
    });
    _loadEntryStats();
  }

  Future<void> _loadEntryStats() async {
    final userId = await provideAuthRepository().resolveQuizSubmitUserId();
    if (!mounted) return;
    if (userId == null) {
      setState(() {
        _entriesLoading = false;
        _entriesUsed = null;
      });
      return;
    }
    try {
      final count =
          await provideQuizRepository().getTotalAttempts(userId: userId);
      if (!mounted) return;
      setState(() {
        _entriesUsed = count < 0 ? 0 : count;
        _entriesLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _entriesLoading = false;
        _entriesUsed = null;
      });
    }
  }

  void _updateRemaining() {
    final now = DateTime.now().toUtc();
    final end = _kCompetitionEndUtc;
    if (now.isAfter(end)) {
      _remaining = Duration.zero;
    } else {
      _remaining = end.difference(now);
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _kBg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: [
                  _DashboardHomeTab(
                    userName: widget.userName,
                    shortlistedEntryRef: widget.shortlistedEntryRef,
                    remaining: _remaining,
                    entriesUsed: _entriesUsed,
                    entriesLoading: _entriesLoading,
                    entriesMax: _kEntriesMax,
                  ),
                  _MyEntriesTab(
                    entriesUsed: _entriesUsed,
                    entriesLoading: _entriesLoading,
                    entriesMax: _kEntriesMax,
                  ),
                  const _AccountTab(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                'Pure skill. One prize. One winner.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _kFooterTagline.withValues(alpha: 0.95),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            _DashboardBottomNav(
              currentIndex: _tabIndex,
              onSelect: (i) => setState(() => _tabIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHomeTab extends StatelessWidget {
  const _DashboardHomeTab({
    required this.userName,
    required this.shortlistedEntryRef,
    required this.remaining,
    required this.entriesUsed,
    required this.entriesLoading,
    required this.entriesMax,
  });

  final String userName;
  final String shortlistedEntryRef;
  final Duration remaining;
  final int? entriesUsed;
  final bool entriesLoading;
  final int entriesMax;

  @override
  Widget build(BuildContext context) {
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24);
    final mins = remaining.inMinutes.remainder(60);
    final secs = remaining.inSeconds.remainder(60);
    final used = entriesUsed;
    final slotsLeft =
        used == null ? null : (entriesMax - used).clamp(0, entriesMax);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CachedNetworkImage(
                      imageUrl: _kLogoUrl,
                      height: 32,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      placeholder: (_, __) => const SizedBox(
                        height: 32,
                        width: 100,
                        child: Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _kOrange,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _IncompleteEntryCard(
              onResume: () {
                Navigator.of(context).pushNamed(
                  QualificationQuizPage.route,
                );
              },
            ),
            const SizedBox(height: 14),
            _ShortlistedCard(entryRef: shortlistedEntryRef),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _StatMiniCard(
                    value:
                        entriesLoading ? '…' : (used == null ? '—' : '$used'),
                    label: 'Entries Used',
                    valueColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatMiniCard(
                    value: entriesLoading
                        ? '…'
                        : (slotsLeft == null ? '—' : '$slotsLeft'),
                    label: 'Slots Left',
                    valueColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatMiniCard(
                    value: '$_kShortlistedStat',
                    label: 'Shortlisted',
                    valueColor: _kShortlistGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Competition Closes In',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kMuted.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _CountdownUnit(
                    value: '$days',
                    unit: 'Days',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CountdownUnit(
                    value: '$hours',
                    unit: 'Hours',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CountdownUnit(
                    value: '$mins',
                    unit: 'Mins',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CountdownUnit(
                    value: '$secs',
                    unit: 'Secs',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [_kOrange, _kOrangeDeep],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _kOrangeGlow,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(PaymentPage.route);
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Add Another Entry →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
              entriesLoading
                  ? 'Loading entry stats…'
                  : (used == null || slotsLeft == null
                      ? 'Entry stats unavailable. Sign in to sync.'
                      : '$used of $entriesMax entries used · $slotsLeft remaining'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kMuted.withValues(alpha: 0.85),
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncompleteEntryCard extends StatelessWidget {
  const _IncompleteEntryCard({required this.onResume});

  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _kOrange.withValues(alpha: 0.85),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Incomplete Entry',
                  style: TextStyle(
                    color: _kOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Payment received — your quiz is waiting.',
                  style: TextStyle(
                    color: const Color(0xFFFFCC80).withValues(alpha: 0.95),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [_kOrange, _kOrangeDeep],
              ),
              boxShadow: [
                BoxShadow(
                  color: _kOrange.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onResume,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Text(
                    'Resume',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortlistedCard extends StatelessWidget {
  const _ShortlistedCard({required this.entryRef});

  final String entryRef;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(ShortlistResultPage.route);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: _kCardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _kShortlistCardBorder.withValues(alpha: 0.9),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF3D3518),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFFFFD54F),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "You're Shortlisted!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Entry #$entryRef · Top 0.01%',
                      style: TextStyle(
                        color: _kMuted.withValues(alpha: 0.92),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: _kMuted.withValues(alpha: 0.7),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  const _StatMiniCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _kCardBorder.withValues(alpha: 0.85),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kMuted.withValues(alpha: 0.88),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  const _CountdownUnit({
    required this.value,
    required this.unit,
  });

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: _kTimerBoxBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: TextStyle(
              color: _kMutedPurple.withValues(alpha: 0.9),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyEntriesTab extends StatelessWidget {
  const _MyEntriesTab({
    required this.entriesUsed,
    required this.entriesLoading,
    required this.entriesMax,
  });

  final int? entriesUsed;
  final bool entriesLoading;
  final int entriesMax;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Entries',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Track your success',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Text.rich(
                  TextSpan(
                    text: entriesLoading
                        ? '… '
                        : entriesUsed == null
                            ? '— '
                            : '$entriesUsed ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      TextSpan(
                        text: '/ $entriesMax',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _EntryRow(
            status: '⭐ Shortlisted',
            date: '14 Mar 2026',
            refNumber: 'TBSC-2026-004521',
            subtitle: '25 words submitted · Top 0.01%',
            statusColor: _kOrange,
            statusBgColor: _kOrange.withValues(alpha: 0.15),
            isShortlisted: true,
          ),
          _EntryRow(
            status: '✓ Submitted',
            date: '12 Mar 2026',
            refNumber: 'TBSC-2026-004486',
            subtitle: '25 words submitted',
            statusColor: Colors.greenAccent,
            statusBgColor: Colors.greenAccent.withValues(alpha: 0.1),
          ),
          Opacity(
            opacity: 0.75,
            child: _EntryRow(
              status: '✗ Quiz Failed',
              date: '10 Mar 2026',
              refNumber: 'TBSC-2026-004412',
              subtitle: 'Did not pass verification',
              statusColor: Colors.redAccent,
              statusBgColor: Colors.redAccent.withValues(alpha: 0.1),
            ),
          ),
          _EntryRow(
            status: '✓ Submitted',
            date: '9 Mar 2026',
            refNumber: 'TBSC-2026-004390',
            subtitle: '25 words submitted',
            statusColor: Colors.greenAccent,
            statusBgColor: Colors.greenAccent.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.status,
    required this.date,
    required this.refNumber,
    required this.subtitle,
    required this.statusColor,
    required this.statusBgColor,
    this.isShortlisted = false,
  });

  final String status;
  final String date;
  final String refNumber;
  final String subtitle;
  final Color statusColor;
  final Color statusBgColor;
  final bool isShortlisted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isShortlisted
            ? _kOrange.withValues(alpha: 0.05)
            : _kCardBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isShortlisted
              ? _kOrange.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: '# ',
              style: TextStyle(
                color: isShortlisted
                    ? _kOrange.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.3),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: refNumber,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountTab extends StatelessWidget {
  const _AccountTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: Colors.white.withValues(alpha: 0.05))),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _kOrange.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Colors.deepPurpleAccent,
                            _kOrange,
                            _kOrangeDeep
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'JD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Jordan Davies',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Member since March 2026',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Account Details'),
          _ActionRowGroup(
            children: [
              _ActionRow(
                icon: Icons.email_outlined,
                iconColor: Colors.white,
                title: 'Email Address',
                subtitle: 'jordan@example.com',
                onTap: () {},
              ),
              _ActionRow(
                icon: Icons.location_on_outlined,
                iconColor: Colors.white,
                title: 'Location',
                subtitle: 'United Kingdom',
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Settings'),
          _ActionRowGroup(
            children: [
              _ActionRow(
                icon: Icons.settings_outlined,
                iconColor: _kOrange,
                title: 'Edit Profile',
                showChevron: true,
                onTap: () {},
              ),
              _ActionRow(
                icon: Icons.description_outlined,
                iconColor: _kMutedPurple,
                title: 'Terms & Privacy',
                showChevron: true,
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          InkWell(
            onTap: () async {
              await provideAuthRepository().signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Color(0xFFFCA5A5),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ActionRowGroup extends StatelessWidget {
  const _ActionRowGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.showChevron = false,
    this.showDivider = true,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool showChevron;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom:
                      BorderSide(color: Colors.white.withValues(alpha: 0.05)))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.2),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBottomNav extends StatelessWidget {
  const _DashboardBottomNav({
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + bottom),
      decoration: const BoxDecoration(
        color: _kNavBg,
        border: Border(
          top: BorderSide(color: Color(0xFF1A1D45)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.psychology_rounded,
            label: 'Dashboard',
            selected: currentIndex == 0,
            activeIconColor: const Color(0xFFFF6B9D),
            onTap: () => onSelect(0),
          ),
          _NavItem(
            icon: Icons.emoji_events_outlined,
            label: 'My Entries',
            selected: currentIndex == 1,
            onTap: () => onSelect(1),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Account',
            selected: currentIndex == 2,
            onTap: () => onSelect(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.activeIconColor,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? activeIconColor;

  @override
  Widget build(BuildContext context) {
    final activeColor = activeIconColor ?? _kOrange;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: selected ? activeColor : _kMuted.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? _kActiveTabLabel
                    : _kMuted.withValues(alpha: 0.5),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            if (selected)
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: _kActiveTabLabel,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
