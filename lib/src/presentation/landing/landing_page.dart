import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_metric/src/presentation/account/account_page.dart';
import 'package:mind_metric/src/presentation/auth/login/login_page.dart';

class _CarouselSlide {
  const _CarouselSlide({
    required this.assetPath,
    required this.kicker,
    required this.title,
    required this.subtitle,
  });

  final String assetPath;
  final String kicker;
  final String title;
  final String subtitle;
}

/// Pre-auth marketing landing: Sign In → login, Enter Now → account creation.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  static const route = '/landing';

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _carouselController = PageController();
  int _carouselIndex = 0;
  Timer? _carouselAutoTimer;

  static const Duration _carouselAutoInterval = Duration(seconds: 5);
  static const Duration _carouselAnimDuration = Duration(milliseconds: 450);

  static const Color _bgTop = Color(0xFF0D1230);
  static const Color _bgMid = Color(0xFF101438);
  static const Color _bgBottom = Color(0xFF151B4A);
  static const Color _muted = Color(0xFFA9AEC1);
  static const Color _accent = Color(0xFFFF9E0F);
  static const Color _gold = Color(0xFFFFD27A);
  static const Color _comingSoonPurple = Color(0xFF6B4FD8);
  static const String _logoUrl =
      'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';

  static const List<_CarouselSlide> _carouselSlides = <_CarouselSlide>[
    _CarouselSlide(
      assetPath: 'assets/images/bmw-x5.jpg',
      kicker: 'FEATURED PRIZE',
      title: 'BMW X5',
      subtitle: 'Premium performance SUV',
    ),
    _CarouselSlide(
      assetPath: 'assets/images/boat.jpg',
      kicker: 'UPCOMING COMPETITION',
      title: '48ft Superyacht',
      subtitle: r'Value ~A$1.2 million',
    ),
    _CarouselSlide(
      assetPath: 'assets/images/caravan.jpg',
      kicker: 'UPCOMING COMPETITION',
      title: 'Luxury caravan',
      subtitle: 'Adventure-ready home on wheels',
    ),
  ];

  /// Some CDNs reject requests without a normal browser-like User-Agent.
  static const Map<String, String> _imageHttpHeaders = <String, String>{
    'User-Agent': 'MindMetric/1.0 (https://thinkpalm.com; Flutter)',
    'Accept': 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scheduleCarouselAutoAdvance();
      }
    });
  }

  void _scheduleCarouselAutoAdvance() {
    _carouselAutoTimer?.cancel();
    if (_carouselSlides.length <= 1) {
      return;
    }
    _carouselAutoTimer = Timer.periodic(_carouselAutoInterval, (_) {
      if (!mounted || !_carouselController.hasClients) {
        return;
      }
      final len = _carouselSlides.length;
      final current = _carouselController.page?.round() ?? _carouselIndex;
      final next = (current + 1) % len;
      _carouselController.animateToPage(
        next,
        duration: _carouselAnimDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _carouselAutoTimer?.cancel();
    _carouselController.dispose();
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_bgTop, _bgMid, _bgBottom],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 20),
                  _buildHero(),
                  const SizedBox(height: 28),
                  _buildCompetitionCarousel(),
                  const SizedBox(height: 14),
                  _buildPageDots(),
                  const SizedBox(height: 24),
                  _buildEnterButton(context),
                  const SizedBox(height: 10),
                  _buildDisclaimer(),
                  const SizedBox(height: 32),
                  _buildHowItWorks(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: CachedNetworkImage(
                imageUrl: _logoUrl,
                httpHeaders: _imageHttpHeaders,
                width: 160,
                height: 36,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
                placeholder: (_, __) => const SizedBox(
                  height: 36,
                  width: 120,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _accent,
                      ),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => const Text(
                  'LE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pushNamed(LoginPage.route),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54, width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            color: _accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x55FF9E0F),
                blurRadius: 20,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: -0.08,
            child: const Text(
              'BIG WIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'The Big Skill Challenge™',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Answer the prompt · Win the prize · Pure skill',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _muted.withValues(alpha: 0.95),
            fontSize: 14,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildCompetitionCarousel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: PageView.builder(
          controller: _carouselController,
          onPageChanged: (i) {
            setState(() => _carouselIndex = i);
            _scheduleCarouselAutoAdvance();
          },
          itemCount: _carouselSlides.length,
          itemBuilder: (context, index) {
            final slide = _carouselSlides[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    slide.assetPath,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF1A2049),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: _muted.withValues(alpha: 0.8),
                        size: 48,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _comingSoonPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'COMING SOON',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00000000),
                          Color(0xCC000000),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          slide.kicker,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slide.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slide.subtitle,
                          style: const TextStyle(
                            color: _gold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_carouselSlides.length, (i) {
        final active = i == _carouselIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? _accent : const Color(0xFF2A3358),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildEnterButton(BuildContext context) {
    return Material(
      color: _accent,
      borderRadius: BorderRadius.circular(28),
      elevation: 4,
      shadowColor: _accent.withValues(alpha: 0.45),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AccountPage.route),
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: const Text(
            'ENTER NOW',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Text(
      'Max 10 entries per participant · Skill-based',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _muted.withValues(alpha: 0.9),
        fontSize: 11,
        height: 1.35,
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.settings_outlined,
              color: _muted.withValues(alpha: 0.85),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'How it Works',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2049),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: CustomPaint(
            painter: _DiagonalStripesPainter(
              color: Colors.white.withValues(alpha: 0.04),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HowStep(
                  number: '1',
                  title: 'Register & Pay',
                  body:
                      'Create your account, confirm eligibility, and purchase entries. Payments held in a designated competition trust account.',
                ),
                SizedBox(height: 20),
                _HowStep(
                  number: '2',
                  title: 'Complete the Qualification Quiz',
                  body:
                      'Pass our timed, skill-based knowledge challenge. 100% correct answers required. Questions drawn from a central bank.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HowStep extends StatelessWidget {
  const _HowStep({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  static const Color _muted = Color(0xFFA9AEC1);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                body,
                style: TextStyle(
                  color: _muted.withValues(alpha: 0.95),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DiagonalStripesPainter extends CustomPainter {
  _DiagonalStripesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 14.0;
    for (double i = -size.height; i < size.width + size.height; i += step) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
