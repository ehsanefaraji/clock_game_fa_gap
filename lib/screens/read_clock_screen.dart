import 'package:flutter/material.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../widgets/analog_clock.dart';

class ReadClockScreen extends StatelessWidget {
  const ReadClockScreen(this.q, this.answer, {super.key});
  final Question q;
  final ValueChanged<int>? answer;
  @override
  Widget build(BuildContext context) => _ClockChoices(q, q.answer, false, answer);
}

class TimeMathScreen extends StatelessWidget {
  const TimeMathScreen(this.q, this.answer, {super.key});
  final Question q;
  final ValueChanged<int>? answer;
  @override
  Widget build(BuildContext context) => _ClockChoices(q, q.start, true, answer);
}

class _ClockChoices extends StatelessWidget {
  const _ClockChoices(this.q, this.time, this.reveal, this.answer);
  final Question q;
  final int time;
  final bool reveal;
  final ValueChanged<int>? answer;
  @override
  Widget build(BuildContext context) => _Panel(child: Column(children: [
    AnalogClock(time: time, reveal: reveal),
    const SizedBox(height: 8),
    _Pairs(children: [for (final t in q.options) _Choice(words(t), answer == null ? null : () => answer?.call(t), correct: answer == null && t == q.answer)]),
  ]));
}

class SetClockScreen extends StatefulWidget {
  const SetClockScreen(this.answer, {super.key, required this.target});
  final int target;
  final ValueChanged<int>? answer;
  @override
  State<SetClockScreen> createState() => _SetClockScreenState();
}

class _SetClockScreenState extends State<SetClockScreen> {
  late int t = widget.target == 0 ? 60 : 0;
  void update(int next, {bool commit = true}) {
    if (widget.answer == null) return;
    setState(() => t = wrapTime(next));
    if (commit) check();
  }
  void check() { if (t == widget.target) widget.answer?.call(t); }
  @override
  Widget build(BuildContext context) {
    final on = widget.answer != null;
    return _Panel(child: Column(children: [
      AnalogClock(time: t, reveal: true, edit: on ? (next) => update(next, commit: false) : null, editEnd: check),
      Text(digital(t), textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      const Text('عقربه را بکش یا از دکمه‌ها کمک بگیر.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
      const SizedBox(height: 8),
      _Pairs(children: [
        _Choice('یک ساعت جلو', on ? () => update(t + 60) : null),
        _Choice('۵ دقیقه جلو', on ? () => update(t + 5) : null),
        _Choice('یک ساعت عقب', on ? () => update(t - 60) : null),
        _Choice('۵ دقیقه عقب', on ? () => update(t - 5) : null),
      ]),
    ]));
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: paper, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2BD90)), boxShadow: const [BoxShadow(color: Color(0x503D2C1E), offset: Offset(0, 4), blurRadius: 12)]),
    child: child,
  );
}

class _Pairs extends StatelessWidget {
  const _Pairs({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
    final width = c.maxWidth < 270 || MediaQuery.textScalerOf(context).scale(16) > 22 ? c.maxWidth : (c.maxWidth - 8) / 2;
    return Wrap(spacing: 8, runSpacing: 8, children: [for (final child in children) SizedBox(width: width, child: child)]);
  });
}

class _Choice extends StatelessWidget {
  const _Choice(this.label, this.action, {this.correct = false});
  final String label;
  final VoidCallback? action;
  final bool correct;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: action,
    style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFDC91), foregroundColor: ink,
      disabledBackgroundColor: correct ? const Color(0xFFBDDFB5) : const Color(0xFFEDE4D7), disabledForegroundColor: ink,
      minimumSize: const Size(0, 48), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
    child: Text(correct ? '✓ $label' : label, textAlign: TextAlign.center, style: const TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
  );
}
