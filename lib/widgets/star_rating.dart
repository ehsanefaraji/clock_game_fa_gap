import 'package:flutter/material.dart';
import '../models/question.dart';
class StarRating extends StatelessWidget {
  const StarRating(this.count,{super.key});
  final int count;
  @override
  Widget build(BuildContext context) => Semantics(label: '${fa(count)} از ۳ ستاره', child: ExcludeSemantics(child: Wrap(
    alignment: WrapAlignment.center,
    spacing: 6,
    children: List.generate(3, (i) => TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: MediaQuery.of(context).disableAnimations || i >= count ? Duration.zero : Duration(milliseconds: 240 + i * 230),
      curve: Interval(i >= count ? 0.0 : i * .23, 1, curve: Curves.easeOutCubic),
      builder: (context, value, child) => Opacity(opacity: value, child: Transform.scale(scale: .65 + value * .35, child: child)),
      child: Icon(i < count ? Icons.star_rounded : Icons.star_border_rounded, color: const Color(0xFF915014), size: 38),
    )),
  )));
}
