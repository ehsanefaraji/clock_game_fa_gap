import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum OwlMood { happy, encouraging, thinking, curious, celebrating }
class Owl extends StatelessWidget {
  const Owl({super.key,this.mood=OwlMood.happy,this.wearing='',this.size=130});
  final OwlMood mood;
  final String wearing;
  final double size;
  @override Widget build(BuildContext context)=>Semantics(label:'جغد ساعت',image:true,child:SizedBox.square(dimension:size,child:Stack(fit:StackFit.expand,children:[Lottie.asset('assets/animations/owl_${mood==OwlMood.celebrating?'celebrate':mood.name}.json',animate:!MediaQuery.of(context).disableAnimations,repeat:mood!=OwlMood.celebrating,errorBuilder:(context,error,stack)=>const Center(child:Text('🦉',style:TextStyle(fontSize:54)))),if(wearing.isNotEmpty) CustomPaint(painter:_Accessory(wearing))])));
}
class _Accessory extends CustomPainter {
  _Accessory(this.item);
  final String item;
  @override void paint(Canvas c,Size s){c.save();c.scale(s.width/160,s.height/160);final p=Paint()..color=const Color(0xFF118AB2);switch(item){case 'hat':c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(54,23,52,27),const Radius.circular(9)),p);c.drawOval(const Rect.fromLTWH(43,44,74,13),p);break;case 'glasses':p..color=const Color(0xFF3D2C1E)..style=PaintingStyle.stroke..strokeWidth=3;c.drawCircle(const Offset(60,72),15,p);c.drawCircle(const Offset(100,72),15,p);c.drawLine(const Offset(75,72),const Offset(85,72),p);break;default:c.drawCircle(const Offset(80,117),17,Paint()..color=const Color(0xFFEF476F));c.drawCircle(const Offset(80,117),8,Paint()..color=const Color(0xFFFFD166));}c.restore();}
  @override bool shouldRepaint(covariant _Accessory old)=>old.item!=item;
}
