import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/question.dart';
import '../models/world.dart';
import '../theme/app_theme.dart';
import 'level_screen.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});
  @override Widget build(BuildContext context){final g=GameScope.of(context);return Sky(title:'نقشهٔ دنیاها',child:Pad(children:[const Text('با سه ستاره، راه مرحلهٔ بعد را باز کن!'),for(var i=0;i<worlds.length;i++)PlayButton(worlds[i]+(g.p.open(i,0)?'':' • قفل'),g.locked||!g.p.open(i,0)?null:()=>go(context,_Trail(i)),color:Color.alphaBlend(worldColors[i].withAlpha(100),paper)),if(g.p.stars['0:9']==3)const Text('نشان استاد ساعت'),if(g.p.stars['3:9']==3)const Text('نشان دقیقه‌شناس'),if(g.p.stars['4:9']==3)const Text('نشان قهرمان زمان')]));}
}
class _Trail extends StatelessWidget {
  const _Trail(this.world);
  final int world;
  static double path(int i)=>sin(i*.88)*.68;
  @override Widget build(BuildContext context){final g=GameScope.of(context);final color=worldColors[world];return Sky(title:worlds[world],child:SingleChildScrollView(padding:const EdgeInsets.all(14),child:CustomPaint(painter:_Dotted(color),child:Column(children:[for(var i=0;i<10;i++) SizedBox(height:102,child:Align(alignment:Alignment(path(i),0),child:SizedBox(width:140,child:PlayButton('مرحلهٔ ${fa(i+1)}\n${g.p.open(world,i)?'★ ${fa(g.p.stars['$world:$i']??0)}':'قفل'}',g.locked||!g.p.open(world,i)?null:()=>go(context,LevelScreen(world,i,Mode.story)),color:Color.alphaBlend(color.withAlpha(130),paper)))))]))));}
}
class _Dotted extends CustomPainter {
  _Dotted(this.color);
  final Color color;
  @override void paint(Canvas canvas,Size size){final p=Path();Offset pt(int i)=>Offset(size.width/2+_Trail.path(i)*(size.width-140)/2,51.0+i*102);p.moveTo(pt(0).dx,pt(0).dy);for(var i=1;i<10;i++){final a=pt(i-1),b=pt(i);p.cubicTo(a.dx,a.dy+52,b.dx,b.dy-52,b.dx,b.dy);}final pen=Paint()..color=color.withAlpha(165);for(final m in p.computeMetrics()){for(double d=0;d<m.length;d+=11){canvas.drawCircle(m.getTangentForOffset(d)!.position,3,pen);}}}
  @override bool shouldRepaint(covariant _Dotted old)=>old.color!=color;
}
