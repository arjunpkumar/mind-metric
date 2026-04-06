import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_metric/src/presentation/quiz/entry_submitted_page.dart';
import 'package:mind_metric/src/presentation/quiz/quiz_time_expired_page.dart';

const Color _kBgTop = Color(0xFF06082A);
const Color _kBgBottom = Color(0xFF0A0E35);
const Color _kMuted = Color(0xFF9CA3C7);
const Color _kCardBg = Color(0xFF12143A);
const Color _kInputBg = Color(0xFF0E1438);
const Color _kGreenBar = Color(0xFF4ADE80);
const Color _kPurpleHint = Color(0xFFB8A9E8);
const Color _kWarningBorder = Color(0xFF7C3AED);
const Color _kWarningText = Color(0xFFFDE68A);
const Color _kCtaStart = Color(0xFFF97316);
const Color _kCtaEnd = Color(0xFFFFBB5C);
const Color _kFooterBg = Color(0xFF030328);

const int _kRequiredWords = 25;
const int _kSecondsTotal = 120;

/// Blocks Ctrl/Cmd+V from inserting pasted text via keyboard shortcuts.
class _BlockPasteIntent extends Intent {
  const _BlockPasteIntent();
}

int _countWords(String text) {
  final t = text.trim();
  if (t.isEmpty) {
    return 0;
  }
  return t.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
}

String _formatTimer(int totalSeconds) {
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// Timed 25-word creative response; paste is disabled in the text field.
class CreativeSubmissionPage extends StatefulWidget {
  const CreativeSubmissionPage({super.key});

  static const route = '/creative-submission';

  static const String prompt =
      'In exactly 25 words, tell us why you should win this prize.';

  @override
  State<CreativeSubmissionPage> createState() => _CreativeSubmissionPageState();
}

class _CreativeSubmissionPageState extends State<CreativeSubmissionPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;
  int _secondsLeft = _kSecondsTotal;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        _timer?.cancel();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => QuizTimeExpiredPage(
              onReturnToCompetitionHome: () => Navigator.of(context).pop(),
            ),
          ),
        );
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onTextChanged() {
    setState(() {
      _wordCount = _countWords(_controller.text);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _secondsLeft > 0 && _wordCount == _kRequiredWords;

  void _submit() {
    if (!_canSubmit) return;
    _timer?.cancel();
    final ref =
        'TBSC-${DateTime.now().year}-${Random().nextInt(1000000).toString().padLeft(6, '0')}';
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: EntrySubmittedPage.route),
        builder: (context) => EntrySubmittedPage(
          wordCount: _wordCount,
          // ignore: avoid_redundant_argument_values — keep in sync if _kRequiredWords changes
          wordTarget: _kRequiredWords,
          entryReference: ref,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerProgress = _secondsLeft / _kSecondsTotal;

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
              colors: [_kBgTop, _kBgBottom],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Creative Submission',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Exactly $_kRequiredWords words required',
                                    style: TextStyle(
                                      color: _kMuted.withValues(alpha: 0.95),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                    color: _secondsLeft <= 10
                                        ? Colors.redAccent
                                        : Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatTimer(_secondsLeft),
                                    style: TextStyle(
                                      color: _secondsLeft <= 10
                                          ? Colors.redAccent
                                          : Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: timerProgress.clamp(0.0, 1.0),
                            minHeight: 4,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.12),
                            color: _kGreenBar,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _kCardBg,
                            borderRadius: BorderRadius.circular(14),
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
                                  color: _kMuted.withValues(alpha: 0.9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '“${CreativeSubmissionPage.prompt}”',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  height: 1.45,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your Response',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$_wordCount / $_kRequiredWords',
                              style: TextStyle(
                                color: _wordCount == _kRequiredWords
                                    ? _kGreenBar
                                    : _kMuted,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Shortcuts(
                          shortcuts: const <ShortcutActivator, Intent>{
                            SingleActivator(
                              LogicalKeyboardKey.keyV,
                              control: true,
                            ): _BlockPasteIntent(),
                            SingleActivator(
                              LogicalKeyboardKey.keyV,
                              meta: true,
                            ): _BlockPasteIntent(),
                          },
                          child: Actions(
                            actions: <Type, Action<Intent>>{
                              _BlockPasteIntent: CallbackAction<_BlockPasteIntent>(
                                onInvoke: (_) => null,
                              ),
                              PasteTextIntent: CallbackAction<PasteTextIntent>(
                                onInvoke: (_) => null,
                              ),
                            },
                            child: TextField(
                              controller: _controller,
                              maxLines: 6,
                              enabled: _secondsLeft > 0,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.4,
                              ),
                              cursorColor: _kCtaStart,
                              decoration: InputDecoration(
                                hintText:
                                    'Type your $_kRequiredWords-word response here...',
                                hintStyle: TextStyle(
                                  color: _kMuted.withValues(alpha: 0.65),
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: _kInputBg,
                                contentPadding: const EdgeInsets.all(14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: _kCtaStart,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                              contextMenuBuilder:
                                  (context, editableTextState) {
                                final items = editableTextState
                                    .contextMenuButtonItems
                                    .where(
                                      (ContextMenuButtonItem item) =>
                                          item.type !=
                                          ContextMenuButtonType.paste,
                                    )
                                    .toList();
                                return AdaptiveTextSelectionToolbar.buttonItems(
                                  anchors:
                                      editableTextState.contextMenuAnchors,
                                  buttonItems: items,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Begin typing your response above.',
                          style: TextStyle(
                            color: _kPurpleHint.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Opacity(
                          opacity: _canSubmit ? 1 : 0.45,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: const LinearGradient(
                                colors: [_kCtaStart, _kCtaEnd],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _kCtaStart.withValues(alpha: 0.4),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _canSubmit ? _submit : null,
                                borderRadius: BorderRadius.circular(28),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: Text(
                                      'Submit Entry →',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF151838),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _kWarningBorder.withValues(alpha: 0.65),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.do_not_disturb_on_rounded,
                                color: Color(0xFFFF8A80),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Paste is disabled. Please type your response. '
                                  'Submission blocked unless word count is '
                                  'exactly $_kRequiredWords.',
                                  style: TextStyle(
                                    color: _kWarningText.withValues(alpha: 0.95),
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
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
                  12,
                  20,
                  12 + MediaQuery.of(context).padding.bottom,
                ),
                color: _kFooterBg,
                child: Text(
                  'Pure skill. One prize. One winner.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _kMuted.withValues(alpha: 0.75),
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
