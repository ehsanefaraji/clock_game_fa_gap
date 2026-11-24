import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
class AnalogClock extends StatefulWidget {
  const AnalogClock({super.key,required this.time,this.edit,this.reveal=false});
  final int time;
  final bool reveal;
  final ValueChanged<int>? edit;
  @override State<AnalogClock> createState()=>_AnalogClockState();
}
class _AnalogClockState extends State<AnalogClock> with SingleTickerProviderStateMixin {
  late final AnimationController a=AnimationController(vsync:this,duration:const Duration(milliseconds:260))..value=1;
  late double from=widget.time.toDouble(),to=from;
  bool hour=false;
  @override void didUpdateWidget(covariant AnalogClock old){super.didUpdateWidget(old); if(old.time!=widget.time){from=value; to=from+((widget.time-from+360)%720)-360; if(widget.edit==null&&!MediaQuery.of(context).disableAnimations){a.forward(from:0);}else{a.value=1;}}}
  double get value=>from+(to-from)*Curves.easeInOut.transform(a.value);
  void drag(Offset point,double side,{bool start=false}){
    final v=point-Offset(side/2,side/2); if(v.distance<12)return;
    if(start) hour=v.distance<side*.29;
    final turn=(atan2(v.dx,-v.dy)/(2*pi))%1;
    final time=widget.time;
    final minute=(turn*12).round()%12*5;
    widget.edit?.call(hour ? wrapTime((turn*12-(time%60)/60).round()*60 + time%60) : wrapTime(time~/60*60+minute));
  }
  @override void dispose(){a.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Center(child:LayoutBuilder(builder:(context,c){final side=min(310.0,c.maxWidth);return Semantics(image:widget.edit==null,label:widget.reveal?'ساعت روی ${words(widget.time)}':'صفحهٔ ساعت؛ از راهنمای عقربه‌ها استفاده کن',child:GestureDetector(excludeFromSemantics:true,onPanStart:widget.edit==null?null:(d)=>drag(d.localPosition,side,start:true),onPanUpdate:widget.edit==null?null:(d)=>drag(d.localPosition,side),child:SizedBox.square(dimension:side,child:AnimatedBuilder(animation:a,builder:(context,_)=>CustomPaint(painter:_Clock(value))))));}));
}
class _Clock extends CustomPainter {
  _Clock(this.t);
  final double t;
  @override void paint(Canvas canvas,Size size){
    final o=size.center(Offset.zero),r=size.shortestSide*.46;
    canvas.drawCircle(o+const Offset(0,5),r,Paint()..color=const Color(0x359B5684)..maskFilter=const MaskFilter.blur(BlurStyle.normal,8));
    canvas.drawCircle(o,r,Paint()..shader=const RadialGradient(colors:[Color(0xFFFFFDF3),Color(0xFFFFE9BB)]).createShader(Rect.fromCircle(center:o,radius:r)));
    canvas.drawCircle(o,r,Paint()..color=const Color(0xFFF1A762)..style=PaintingStyle.stroke..strokeWidth=5);
    final dots=Random(7);
    for(var i=0;i<170;i++){final ang=dots.nextDouble()*2*pi;final d=sqrt(dots.nextDouble())*r*.96;canvas.drawCircle(o+Offset(cos(ang),sin(ang))*d,.55,Paint()..color=const Color(0x20B78152));}
    for(var i=0;i<60;i++){
      final angle=i*pi/30;
      final dir=Offset(sin(angle),-cos(angle));
      final major=i%5==0;
      canvas.drawLine(o+dir*r*.91,o+dir*r*(major ? .83 : .88),Paint()..color=(major?ink:const Color(0xFFAF7854))..strokeWidth=(major?2.6:1)..strokeCap=StrokeCap.round);
      if(major){final p=TextPainter(text:TextSpan(text:fa(i==0?12:i~/5),style:TextStyle(fontFamily:'Vazirmatn',fontWeight:FontWeight.bold,fontSize:r*.17,color:ink,shadows:const [Shadow(color:Color(0x30A06C41),offset:Offset(0,1),blurRadius:2)])),textDirection:TextDirection.rtl)..layout();p.paint(canvas,o+dir*r*.71-Offset(p.width/2,p.height/2));}
    }
    void hand(double turn,double length,double thickness,Color color){final a=turn*pi*2;final tip=o+Offset(sin(a),-cos(a))*r*length;canvas.drawLine(o,tip,Paint()..color=color.withAlpha(100)..strokeWidth=thickness+4..strokeCap=StrokeCap.round..maskFilter=const MaskFilter.blur(BlurStyle.normal,4));canvas.drawLine(o,tip,Paint()..color=color..strokeWidth=thickness..strokeCap=StrokeCap.round);}
    hand(t/720,.46,r*.083,const Color(0xFF118AB2));hand(t/60,.65,r*.053,const Color(0xFFE87528));canvas.drawCircle(o,r*.052,Paint()..color=ink);
  }
  @override bool shouldRepaint(covariant _Clock old)=>old.t!=t;
}
