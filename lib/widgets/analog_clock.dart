import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';

const _hourInk = Color(0xFF16748B);
const _minuteInk = Color(0xFFB9541C);

class AnalogClock extends StatefulWidget {
  const AnalogClock({super.key, required this.time, this.edit, this.editEnd, this.reveal = false});
  final int time;
  final bool reveal;
  final ValueChanged<int>? edit;
  final VoidCallback? editEnd;
  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  bool? hour;
  int? tick;

  void drag(Offset point, double side, {bool start = false}) {
    final v = point - Offset(side / 2, side / 2);
    final r = side * .46;
    if (v.distance < 12) return;
    if (start) {
      Offset tip(double turn, double length) => Offset(sin(turn * 2 * pi), -cos(turn * 2 * pi)) * r * length;
      final h = (v - tip(widget.time / 720, .46)).distance;
      final m = (v - tip(widget.time / 60, .72)).distance;
      hour = min(h, m) < r * .20 ? h < m : v.distance < r * .58;
    }
    final isHour = hour;
    if (isHour == null) return;
    final turn = (atan2(v.dx, -v.dy) / (2 * pi)) % 1;
    final division = (turn * 12 - (isHour ? (widget.time % 60) / 60 : 0)).round() % 12;
    setState(() => tick = (turn * 12).round() % 12);
    final time = widget.time;
    widget.edit?.call(isHour ? division * 60 + time % 60 : time ~/ 60 * 60 + division * 5);
  }

  void stop({required bool commit}) {
    setState(() { tick = null; hour = null; });
    if (commit) widget.editEnd?.call();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
    final side = min(c.maxWidth, (MediaQuery.sizeOf(context).height * .43).clamp(210.0, 330.0).toDouble());
    final editable = widget.edit != null;
    return Column(children: [
      Semantics(image: !editable, label: widget.reveal ? 'ساعت روی ${words(widget.time)}' : 'صفحهٔ ساعت',
        child: GestureDetector(behavior: HitTestBehavior.opaque, excludeFromSemantics: true,
          onPanStart: editable ? (d) => drag(d.localPosition, side, start: true) : null,
          onPanUpdate: editable ? (d) => drag(d.localPosition, side) : null,
          onPanEnd: editable ? (_) => stop(commit: true) : null,
          onPanCancel: editable ? () => stop(commit: false) : null,
          child: SizedBox.square(dimension: side, child: CustomPaint(painter: _Clock(widget.time, tick, hour))),
        ),
      ),
      const Wrap(alignment: WrapAlignment.center, spacing: 14, children: [
        Text('━ ساعت‌شمار', style: TextStyle(color: _hourInk, fontSize: 13, fontWeight: FontWeight.bold)),
        Text('─ دقیقه‌شمار', style: TextStyle(color: _minuteInk, fontSize: 13, fontWeight: FontWeight.bold)),
      ]),
    ]);
  });
}

class _Clock extends CustomPainter {
  _Clock(this.time, this.tick, this.hour);
  final int time;
  final int? tick;
  final bool? hour;
  @override
  void paint(Canvas canvas, Size size) {
    final o = size.center(Offset.zero), r = size.shortestSide * .46;
    canvas.drawCircle(o + const Offset(0, 4), r, Paint()..color = const Color(0x40915635)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    canvas.drawCircle(o, r, Paint()..shader = const RadialGradient(colors: [Color(0xFFFFFDF6), Color(0xFFFFEAC5)]).createShader(Rect.fromCircle(center: o, radius: r)));
    canvas.drawCircle(o, r, Paint()..color = const Color(0xFFBD7C42)..style = PaintingStyle.stroke..strokeWidth = 5);
    for (var i = 0; i < 60; i++) {
      final angle = i * pi / 30;
      final dir = Offset(sin(angle), -cos(angle));
      final major = i % 5 == 0;
      final active = tick != null && tick! * 5 == i;
      final accent = hour == true ? _hourInk : _minuteInk;
      if (active) canvas.drawCircle(o + dir * r * .72, r * .13, Paint()..color = accent.withValues(alpha: .18));
      canvas.drawLine(o + dir * r * .92, o + dir * r * (major ? .84 : .89), Paint()..color = (active ? accent : major ? ink : const Color(0xFFAF7854))..strokeWidth = (major ? 2.5 : 1)..strokeCap = StrokeCap.round);
      if (major) {
        final p = TextPainter(text: TextSpan(text: fa(i == 0 ? 12 : i ~/ 5), style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: r * .18, color: ink)), textDirection: TextDirection.rtl)..layout();
        p.paint(canvas, o + dir * r * .72 - Offset(p.width / 2, p.height / 2));
      }
    }
    void hand(double turn, double length, double width, Color color) {
      final a = turn * pi * 2;
      canvas.drawLine(o, o + Offset(sin(a), -cos(a)) * r * length, Paint()..color = color..strokeWidth = r * width..strokeCap = StrokeCap.round);
    }
    hand(time / 720, .46, .105, _hourInk);
    hand(time / 60, .72, .045, _minuteInk);
    canvas.drawCircle(o, r * .055, Paint()..color = ink);
    canvas.drawCircle(o, r * .023, Paint()..color = paper);
  }
  @override
  bool shouldRepaint(covariant _Clock old) => old.time != time || old.tick != tick || old.hour != hour;
}
