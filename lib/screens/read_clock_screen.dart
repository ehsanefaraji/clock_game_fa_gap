import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../widgets/analog_clock.dart';

class ReadClockScreen extends StatelessWidget {
  const ReadClockScreen(this.q, this.answer, {super.key});
  final Question q;
  final ValueChanged<int>? answer;
  @override Widget build(BuildContext context) {
    final on = answer != null;
    return Column(children: [
      // ساعت داخل کارت شناور
      _PopupCard(child: AnalogClock(time: q.answer)),
      const SizedBox(height: 10),
      // گزینه‌ها داخل کارت شناور
      _PopupCard(child: Column(children: [
        for (final t in q.options) Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _OptionButton(
            text: words(t),
            onTap: on ? () => answer!(t) : null,
            isAnswer: t == q.answer,
            enabled: on,
          ),
        ),
      ])),
    ]);
  }
}

class TimeMathScreen extends StatelessWidget {
  const TimeMathScreen(this.q, this.answer, {super.key});
  final Question q;
  final ValueChanged<int>? answer;
  @override Widget build(BuildContext context) {
    final on = answer != null;
    return Column(children: [
      // ساعت شروع داخل کارت
      _PopupCard(child: Column(children: [
        AnalogClock(time: q.start, reveal: true),
      ])),
      const SizedBox(height: 10),
      // گزینه‌ها داخل کارت
      _PopupCard(child: Column(children: [
        for (final t in q.options) Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _OptionButton(
            text: words(t),
            onTap: on ? () => answer!(t) : null,
            isAnswer: t == q.answer,
            enabled: on,
          ),
        ),
      ])),
    ]);
  }
}

class SetClockScreen extends StatefulWidget {
  const SetClockScreen(this.answer, {super.key});
  final ValueChanged<int>? answer;
  @override State<SetClockScreen> createState() => _SetClockScreenState();
}

class _SetClockScreenState extends State<SetClockScreen> {
  int t = 0;
  void update(int next) => setState(() => t = wrapTime(next));
  @override Widget build(BuildContext context) {
    final on = widget.answer != null;
    return Column(children: [
      // ساعت تعاملی داخل کارت
      _PopupCard(child: Column(children: [
        AnalogClock(time: t, reveal: true, edit: on ? update : null),
        Text(digital(t), textDirection: TextDirection.ltr,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ink)),
      ])),
      const SizedBox(height: 10),
      // دکمه‌ها داخل کارت
      _PopupCard(child: Column(children: [
        const Text('عقربه را بکش یا از دکمه‌ها کمک بگیر.', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _SmallButton('⬅ ساعت جلو', on ? () => update(t + 60) : null)),
          const SizedBox(width: 6),
          Expanded(child: _SmallButton('⬅ ۵ دقیقه', on ? () => update(t + 5) : null)),
        ]),
        Row(children: [
          Expanded(child: _SmallButton('➡ ساعت عقب', on ? () => update(t - 60) : null)),
          const SizedBox(width: 6),
          Expanded(child: _SmallButton('➡ ۵ دقیقه', on ? () => update(t - 5) : null)),
        ]),
        const SizedBox(height: 10),
        _OptionButton(text: '✅ بررسی ساعت', onTap: on ? () => widget.answer!(t) : null, isAnswer: false, enabled: on),
      ])),
    ]);
  }
}

// --- Widgets ---

class _PopupCard extends StatelessWidget {
  const _PopupCard({required this.child});
  final Widget child;
  @override Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.15), offset: const Offset(0, 4), blurRadius: 12),
        BoxShadow(color: Colors.white.withValues(alpha: 0.3), offset: const Offset(0, 2), blurRadius: 4),
      ],
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: child,
  );
}

class _OptionButton extends StatefulWidget {
  const _OptionButton({required this.text, required this.onTap, required this.isAnswer, required this.enabled});
  final String text;
  final VoidCallback? onTap;
  final bool isAnswer;
  final bool enabled;
  @override State<_OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<_OptionButton> with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  @override void dispose() { _shake.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
    animation: _shake,
    builder: (context, child) => Transform.translate(
      offset: Offset(sin(_shake.value * pi * 6) * 4 * (1 - _shake.value), 0),
      child: child,
    ),
    child: SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: widget.onTap == null ? const Color(0xFFEADFDB) : const Color(0xFFFFD93D),
        borderRadius: BorderRadius.circular(16),
        elevation: widget.onTap == null ? 0 : 3,
        shadowColor: const Color(0x40774664),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTap,
          child: Center(child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ink,
              height: 1.3,
            ),
          )),
        ),
      ),
    ),
  );
}

class _SmallButton extends StatelessWidget {
  const _SmallButton(this.label, this.onTap);
  final String label;
  final VoidCallback? onTap;
  @override Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: Material(
      color: onTap == null ? const Color(0xFFEADFDB) : paper,
      borderRadius: BorderRadius.circular(12),
      elevation: onTap == null ? 0 : 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ink))),
      ),
    ),
  );
}
