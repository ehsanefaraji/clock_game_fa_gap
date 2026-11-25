import 'package:flutter/material.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../widgets/analog_clock.dart';
class SetClockScreen extends StatefulWidget {
  const SetClockScreen(this.answer,{super.key});
  final ValueChanged<int>? answer;
  @override State<SetClockScreen> createState()=>_SetClockScreenState();
}
class _SetClockScreenState extends State<SetClockScreen> {
  int t=0;
  void update(int next)=>setState(()=>t=wrapTime(next));
  @override Widget build(BuildContext context){
    final on=widget.answer!=null;
    return Column(children:[
      AnalogClock(time:t,reveal:true,edit:on?update:null),
      Text(digital(t),textDirection:TextDirection.ltr,style:Theme.of(context).textTheme.titleLarge),
      const Text('عقربه را بکش یا از دکمه‌ها کمک بگیر.',textAlign:TextAlign.center),
      const SizedBox(height:8),
      Row(children:[
        Expanded(child:PlayButton('⬅ یک ساعت جلو',on?()=>update(t+60):null,color:paper)),
        const SizedBox(width:8),
        Expanded(child:PlayButton('⬅ پنج دقیقه جلو',on?()=>update(t+5):null,color:paper)),
      ]),
      Row(children:[
        Expanded(child:PlayButton('➡ یک ساعت عقب',on?()=>update(t-60):null,color:paper)),
        const SizedBox(width:8),
        Expanded(child:PlayButton('➡ پنج دقیقه عقب',on?()=>update(t-5):null,color:paper)),
      ]),
      const SizedBox(height:12),
      PlayButton('✅ بررسی ساعت',on?()=>widget.answer!(t):null,color:const Color(0xFF00B894)),
    ]);
  }
}
