import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mind_metric/src/presentation/dashboard/dashboard_page.dart';

const Color _kBg = Color(0xFF050533);
const Color _kSuccessGreen = Color(0xFF28C76F);
const Color _kCardBg = Color(0xFF0E1040);
const Color _kMuted = Color(0xFF9CA3C7);
const Color _kCtaStart = Color(0xFFFF8C00);
const Color _kCtaEnd = Color(0xFFEA580C);
const Color _kFooterBg = Color(0xFF030328);

const String _kLogoUrl =
    'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';

/// Shown after creative submission is recorded successfully.
class EntrySubmittedPage extends StatelessWidget {
  const EntrySubmittedPage({
    super.key,
    this.wordCount = 25,
    this.wordTarget = 25,
    this.entryReference = 'TBSC-2026-004521',
    this.submittedAt,
  });

  static const route = '/entry-submitted';

  final int wordCount;
  final int wordTarget;
  final String entryReference;
  final DateTime? submittedAt;

  String get _submittedLabel {
    final dt = (submittedAt ?? DateTime.now()).toUtc();
    return DateFormat("d MMM yyyy, HH:mm 'UTC'", 'en').format(dt);
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
                                  color: _kCtaStart,
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
                                spreadRadius: 2,
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
                      const SizedBox(height: 18),
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
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: _kSuccessGreen,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Entry Accepted!',
                                style: TextStyle(
                                  color: _kSuccessGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Entry Accepted!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your entry has been successfully submitted and recorded.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _kMuted.withValues(alpha: 0.95),
                          fontSize: 15,
                          height: 1.45,
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
                          children: [
                            _DetailRow(
                              label: 'Word Count',
                              valueWidget: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$wordCount / $wordTarget',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: _kSuccessGreen,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            _DetailRow(
                              label: 'Entry Reference',
                              value: entryReference,
                            ),
                            const SizedBox(height: 14),
                            _DetailRow(
                              label: 'Submitted',
                              value: _submittedLabel,
                            ),
                            const SizedBox(height: 14),
                            _DetailRow(
                              label: 'Status',
                              valueWidget: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Entry Recorded',
                                    style: TextStyle(
                                      color: _kSuccessGreen.withValues(
                                        alpha: 0.98,
                                      ),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: _kSuccessGreen,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'A confirmation email has been sent to your registered '
                        'email address.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _kMuted.withValues(alpha: 0.88),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [_kCtaStart, _kCtaEnd],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _kCtaStart.withValues(alpha: 0.4),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                DashboardPage.route,
                                (route) => false,
                                arguments: DashboardRouteArgs(
                                  shortlistedEntryRef: entryReference,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(28),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'Return to Dashboard',
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
              color: _kFooterBg,
              child: const Text(
                'Pure skill. One prize. One winner.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    this.value,
    this.valueWidget,
  }) : assert(value != null || valueWidget != null);

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: _kMuted.withValues(alpha: 0.95),
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: valueWidget ??
                Text(
                  value!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
