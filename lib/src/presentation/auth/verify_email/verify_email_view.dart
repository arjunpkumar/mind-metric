import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_metric/src/application/bloc/account/account_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/verify_email/verify_email_bloc.dart';
import 'package:mind_metric/src/application/bloc/auth/verify_email/verify_email_event.dart';
import 'package:mind_metric/src/application/bloc/auth/verify_email/verify_email_state.dart';
import 'package:mind_metric/src/presentation/auth/login/login_page.dart';

const Color _kBg = Color(0xFF101438);
const Color _kBoxBg = Color(0xFF151B40);
const Color _kYellow = Color(0xFFFFE066);
const Color _kOrange = Color(0xFFFF9E0F);
const Color _kRed = Color(0xFFE53935);
const Color _kMuted = Color(0xFFB8BFD4);
const Color _kInfoBg = Color(0xFF2A1F45);
const String _kLogoUrl =
    'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({
    super.key,
    required this.maskedEmail,
    this.accountBloc,
  });

  final String maskedEmail;
  final AccountBloc? accountBloc;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocListener<VerifyEmailBloc, VerifyEmailState>(
        listenWhen: (p, c) => p.sendErrorMessage != c.sendErrorMessage,
        listener: (context, state) {
          final msg = state.sendErrorMessage;
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                behavior: SnackBarBehavior.floating,
                backgroundColor: _kBoxBg,
              ),
            );
          }
        },
        child: BlocConsumer<VerifyEmailBloc, VerifyEmailState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == VerifyEmailStatus.success) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                LoginPage.route,
                (_) => false,
              );
            } else if (state.status == VerifyEmailStatus.failure &&
                state.errorMessage != null &&
                state.otpCode.length == 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _kBoxBg,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: _kBg,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                title: CachedNetworkImage(
                  imageUrl: _kLogoUrl,
                  height: 32,
                  fit: BoxFit.contain,
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
                centerTitle: true,
              ),
            body: Column(
              children: [
                if (state.initialSendInProgress)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    color: _kOrange,
                    backgroundColor: Color(0xFF1A2049),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            width: 112,
                            height: 112,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFF7C4DFF),
                                  Color(0xFFFF9800),
                                ],
                                center: Alignment(-0.35, -0.35),
                                radius: 0.95,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x448855FF),
                                  blurRadius: 24,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mail_outline_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Verify Your Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'A verification code has been sent to your email address.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          maskedEmail,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _kYellow,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Enter 6-digit verification code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _VerifyOtpRow(
                          code: state.otpCode,
                          onChanged: (code) => context
                              .read<VerifyEmailBloc>()
                              .add(VerifyEmailOtpUpdated(code)),
                        ),
                        if (state.errorMessage != null &&
                            state.otpCode.length < 6) ...[
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 28),
                        _VerifyGradientButton(
                          loading:
                              state.status == VerifyEmailStatus.verifying,
                          enabled: state.canVerify,
                          onPressed: () => context
                              .read<VerifyEmailBloc>()
                              .add(const VerifyEmailSubmitted()),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Did not receive the code?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _kMuted.withValues(alpha: 0.95),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: GestureDetector(
                            onTap: state.canResend
                                ? () => context
                                    .read<VerifyEmailBloc>()
                                    .add(const VerifyEmailResendRequested())
                                : null,
                            child: Text(
                              state.resendCooldownSeconds > 0
                                  ? 'Code resent (${state.resendCooldownSeconds}s)'
                                  : 'Resend Code',
                              style: TextStyle(
                                color: state.canResend
                                    ? _kYellow
                                    : _kMuted,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: state.canResend
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                decorationColor: _kYellow,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const _SpamInfoBox(),
                        const SizedBox(height: 32),
                        Text(
                          'Pure skill. One prize. One winner.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 11,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        ),
      ),
    );
  }
}

class _VerifyOtpRow extends StatefulWidget {
  const _VerifyOtpRow({
    required this.code,
    required this.onChanged,
  });

  final String code;
  final ValueChanged<String> onChanged;

  @override
  State<_VerifyOtpRow> createState() => _VerifyOtpRowState();
}

class _VerifyOtpRowState extends State<_VerifyOtpRow> {
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (_) => FocusNode());
    _controllers = List.generate(
      6,
      (i) => TextEditingController(
        text: i < widget.code.length ? widget.code[i] : '',
      ),
    );
    for (var i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant _VerifyOtpRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      for (var i = 0; i < 6; i++) {
        final ch = i < widget.code.length ? widget.code[i] : '';
        if (_controllers[i].text != ch) {
          _controllers[i].text = ch;
        }
      }
    }
  }

  @override
  void dispose() {
    for (final n in _focusNodes) {
      n.dispose();
    }
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String _merged() {
    return _controllers.map((c) => c.text).join();
  }

  void _emit() {
    widget.onChanged(_merged());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i > 0 ? 6 : 0),
            child: SizedBox(
              height: 52,
              child: TextField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: _kOrange,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: _kBoxBg,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _kOrange, width: 1.2),
                  ),
                ),
                onChanged: (v) {
                  if (v.isNotEmpty && i < 5) {
                    _focusNodes[i + 1].requestFocus();
                  }
                  if (v.isEmpty && i > 0) {
                    _focusNodes[i - 1].requestFocus();
                  }
                  _emit();
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _VerifyGradientButton extends StatelessWidget {
  const _VerifyGradientButton({
    required this.onPressed,
    required this.enabled,
    required this.loading,
  });

  final VoidCallback onPressed;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled || loading ? 1 : 0.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [_kOrange, _kRed],
          ),
          boxShadow: [
            BoxShadow(
              color: _kOrange.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled && !loading ? onPressed : null,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Verify →',
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
    );
  }
}

class _SpamInfoBox extends StatelessWidget {
  const _SpamInfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kInfoBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _kOrange.withValues(alpha: 0.65),
        ),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            height: 1.45,
          ),
          children: [
            TextSpan(text: '📧 '),
            TextSpan(
              text: 'Check your spam folder',
              style: TextStyle(
                color: _kYellow,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text:
                  " if you don't see the email within ",
            ),
            TextSpan(
              text: '2 minutes',
              style: TextStyle(
                color: _kYellow,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: '. The code is valid for '),
            TextSpan(
              text: '10 minutes',
              style: TextStyle(
                color: _kYellow,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}
