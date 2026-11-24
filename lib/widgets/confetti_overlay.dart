import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class ConfettiOverlay extends StatelessWidget {
  const ConfettiOverlay({super.key});
  @override Widget build(BuildContext context)=> IgnorePointer(child:ExcludeSemantics(child:MediaQuery.of(context).disableAnimations?const SizedBox.shrink():Lottie.asset('assets/animations/confetti.json',fit:BoxFit.contain,repeat:false)));
}
