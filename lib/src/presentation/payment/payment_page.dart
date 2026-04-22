import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_metric/src/presentation/home/home_page.dart';

const Color _kBgGradientStart = Color(0xFF1E0A4E); // roughly matching the deep #1a0a4e
const Color _kBgGradientEnd = Color(0xFF0D0030);
const Color _kStripeBlue = Color(0xFF635BFF);
const Color _kInputBg = Color(0xFFF9FAFB);
const Color _kInputBorder = Color(0xFFD1D5DB);
const Color _kTextDark = Color(0xFF111827);
const Color _kTextMuted = Color(0xFF9CA3AF);

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  static const route = '/payment';

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF08002E),
        body: Column(
          children: [
            // Dark Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Secure Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Powered by Stripe',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _kStripeBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: const Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), // Simplistic S
                    ),
                  ],
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildOrderBanner(),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildStripeSheet(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_kBgGradientStart, _kBgGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text('🏆', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'The Big Skill Challenge™',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'bigskillchallenge.com.au',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'AUD',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'A\$2.99',
                        style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'BMW X5 SUV — 1 Competition Entry',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TRUST ACCOUNT',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Icon(Icons.verified_user_outlined, color: Colors.greenAccent, size: 28),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStripeSheet(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Contact section
          const Text(
            'CONTACT',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1),
          ),
          const SizedBox(height: 10),
          _buildLabel('Email'),
          _buildTextField(hintText: 'you@example.com', keyboardType: TextInputType.emailAddress),
          
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('PAYMENT DETAILS', style: TextStyle(color: _kTextMuted, fontSize: 11, fontWeight: FontWeight.w500)),
              ),
              Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
            ],
          ),
          const SizedBox(height: 20),

          // Card information
          _buildLabel('Card information'),
          Container(
            decoration: BoxDecoration(
              color: _kInputBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kInputBorder, width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '1234 1234 1234 1234',
                          hintStyle: const TextStyle(color: _kTextMuted, fontSize: 15),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        style: const TextStyle(color: _kTextDark, fontSize: 15),
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CardBrand(name: 'VISA', bg: Color(0xFF1A1F71)),
                        SizedBox(width: 4),
                        _CardBrand(name: 'MC', bg: Color(0xFFEB001B)),
                        SizedBox(width: 4),
                        _CardBrand(name: 'AMEX', bg: Color(0xFF2E77BC), isSmall: true),
                        SizedBox(width: 14),
                      ],
                    ),
                  ],
                ),
                Container(height: 1.5, color: const Color(0xFFE5E7EB)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'MM / YY',
                          hintStyle: const TextStyle(color: _kTextMuted, fontSize: 15),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        style: const TextStyle(color: _kTextDark, fontSize: 15),
                      ),
                    ),
                    Container(width: 1.5, height: 46, color: const Color(0xFFE5E7EB)),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'CVC',
                          hintStyle: const TextStyle(color: _kTextMuted, fontSize: 15),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        style: const TextStyle(color: _kTextDark, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          _buildLabel('Name on card'),
          _buildTextField(hintText: 'Full name as on card'),

          const SizedBox(height: 12),
          _buildLabel('Country or region'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _kInputBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kInputBorder, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('🇦🇺 Australia', style: TextStyle(color: _kTextDark, fontSize: 15)),
                Icon(Icons.arrow_drop_down, color: _kTextMuted, size: 20),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              border: Border.all(color: const Color(0xFFFDE68A)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '⚠ Session recovery: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: 'If payment succeeds but your session is interrupted, your entry credit is preserved and can be resumed within the competition window.'),
                ],
              ),
              style: const TextStyle(color: Color(0xFF92400E), fontSize: 12, height: 1.5),
            ),
          ),
          
          const SizedBox(height: 20),
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(HomePage.route),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _kStripeBlue,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Color(0x66635BFF), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              alignment: Alignment.center,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Pay A\$2.99', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSecurityBadge('🔒', 'TLS 1.3'),
              const SizedBox(width: 12),
              _buildSecurityBadge('✓', 'PCI DSS Level 1'),
              const SizedBox(width: 12),
              _buildSecurityBadge('🛡', '3D Secure'),
            ],
          ),
          
          const Spacer(),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Powered by ', style: TextStyle(color: _kTextMuted, fontSize: 11, fontWeight: FontWeight.w500)),
              Text('stripe', style: TextStyle(color: _kStripeBlue, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            ],
          ),
          
          const SizedBox(height: 16),
          Text(
            'By confirming payment you agree to the Competition Terms & Conditions and Privacy Policy.\nEntry fee processed into a designated competition trust account. A\$2.99 AUD per entry.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kTextMuted, fontSize: 10, height: 1.5),
          ),
          // Need some bottom padding to account for the bottom of screen
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF374151), fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({required String hintText, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: _kInputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _kInputBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _kInputBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _kStripeBlue, width: 1.5),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: _kTextMuted, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      style: const TextStyle(color: _kTextDark, fontSize: 15),
    );
  }

  Widget _buildSecurityBadge(String emoji, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 10, color: _kTextMuted)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, color: _kTextMuted, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _CardBrand extends StatelessWidget {
  const _CardBrand({required this.name, required this.bg, this.isSmall = false});
  final String name;
  final Color bg;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 18,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        style: TextStyle(color: Colors.white, fontSize: isSmall ? 6 : 7, fontWeight: FontWeight.w900),
      ),
    );
  }
}
