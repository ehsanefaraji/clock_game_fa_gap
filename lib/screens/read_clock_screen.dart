import 'package:flutter/material.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../widgets/analog_clock.dart';
class ReadClockScreen extends StatelessWidget {
  const ReadClockScreen(this.q,this.answer,{super.key});
  final Question q;
  final ValueChanged<int>? answer;
  @override Widget build(BuildContext context)=>Column(children:[AnalogClock(time:q.answer),for(final t in q.options) Padding(padding:const EdgeInsets.only(top:8),child:PlayButton(words(t),answer==null?null:()=>answer!(t),color:paper))]);
}
