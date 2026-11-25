import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/question.dart';
import '../models/world.dart';
import '../theme/app_theme.dart';
import 'level_screen.dart';

const worldEmojis = ['🌲','☁️','🏰','⚙️','⏰'];
const worldDescriptions = [
  'ساعت‌های کامل را یاد بگیر',
  'نیم ساعت را کشف کن',
  'ربع ساعت را بشناس',
  'دقیقه‌های پنج‌تایی را تمرین کن',
  'چالش ترکیبی همهٔ آموخته‌ها',
];

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});
  @override Widget build(BuildContext context){
    final g=GameScope.of(context);
    return Sky(title:'🗺️ نقشهٔ دنیاها',child:ListView(padding:const EdgeInsets.fromLTRB(18,12,18,24),children:[
      Container(
        padding:const EdgeInsets.all(16),
        margin:const EdgeInsets.only(bottom:16),
        decoration:BoxDecoration(
          gradient:const LinearGradient(colors:[Color(0xFF6C5CE7),Color(0xFFA29BFE)]),
          borderRadius:BorderRadius.circular(20),
          boxShadow:[BoxShadow(color:const Color(0xFF6C5CE7).withValues(alpha:0.3),offset:const Offset(0,4),blurRadius:10)],
        ),
        child:const Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children:[
            Text('🌈 همهٔ دنیاها باز هستند!',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white)),
          ],
        ),
      ),
      for(var i=0;i<worlds.length;i++)...[
        _WorldCard(
          index:i,
          name:worlds[i],
          emoji:worldEmojis[i],
          description:worldDescriptions[i],
          color:worldColors[i],
          stars:g.p.stars,
          onTap:g.locked?null:()=>go(context,_Trail(i)),
        ),
        if(i<worlds.length-1)const SizedBox(height:4,child:Center(child:Icon(Icons.expand_more,color:Colors.grey,size:20))),
      ],
      if(g.p.stars['0:9']==3) _BadgeCard('🏅','نشان استاد ساعت','همهٔ مراحل جنگل را با سه ستاره کامل کردی',const Color(0xFF00B894)),
      if(g.p.stars['3:9']==3) _BadgeCard('🏅','نشان دقیقه‌شناس','همهٔ مراحل دقیقه‌ها را با سه ستاره کامل کردی',const Color(0xFF0984E3)),
      if(g.p.stars['4:9']==3) _BadgeCard('🏅','نشان قهرمان زمان','همهٔ چالش‌ها را با سه ستاره کامل کردی',const Color(0xFFEF476F)),
    ]));
  }
}

class _WorldCard extends StatelessWidget {
  final int index;
  final String name, emoji, description;
  final Color color;
  final Map<String,int> stars;
  final VoidCallback? onTap;
  const _WorldCard({required this.index,required this.name,required this.emoji,required this.description,required this.color,required this.stars,required this.onTap});
  @override Widget build(BuildContext context){
    final totalStars = List.generate(10,(l)=>stars['$index:$l']??0).fold<int>(0,(a,b)=>a+b);
    return Container(
      margin:const EdgeInsets.only(bottom:8),
      decoration:BoxDecoration(
        gradient:LinearGradient(
          begin:Alignment.topLeft,end:Alignment.bottomRight,
          colors:[color.withValues(alpha:0.9),color.withValues(alpha:0.6)],
        ),
        borderRadius:BorderRadius.circular(24),
        boxShadow:[BoxShadow(color:color.withValues(alpha:0.3),offset:const Offset(0,6),blurRadius:12)],
        border:Border.all(color:Colors.white.withValues(alpha:0.3),width:2),
      ),
      child:Material(
        color:Colors.transparent,
        child:InkWell(
          borderRadius:BorderRadius.circular(24),
          onTap:onTap,
          child:Padding(
            padding:const EdgeInsets.all(16),
            child:Row(
              children:[
                Container(
                  width:64,height:64,
                  decoration:BoxDecoration(
                    color:Colors.white.withValues(alpha:0.25),
                    borderRadius:BorderRadius.circular(18),
                    border:Border.all(color:Colors.white.withValues(alpha:0.4),width:2),
                  ),
                  child:Center(child:Text(emoji,style:const TextStyle(fontSize:36))),
                ),
                const SizedBox(width:14),
                Expanded(
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      Text(name,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900,color:Colors.white)),
                      const SizedBox(height:2),
                      Text(description,style:TextStyle(fontSize:13,color:Colors.white.withValues(alpha:0.85))),
                      const SizedBox(height:4),
                      Row(
                        children:[
                          const Icon(Icons.star,color:Color(0xFFFFD93D),size:16),
                          const SizedBox(width:4),
                          Text('$totalStars / ۳۰ ستاره',style:TextStyle(fontSize:12,color:Colors.white.withValues(alpha:0.9),fontWeight:FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left,color:Colors.white,size:28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color color;
  const _BadgeCard(this.emoji,this.title,this.subtitle,this.color);
  @override Widget build(BuildContext context)=>Container(
    margin:const EdgeInsets.only(top:12),
    padding:const EdgeInsets.all(14),
    decoration:BoxDecoration(
      color:color.withValues(alpha:0.15),
      borderRadius:BorderRadius.circular(16),
      border:Border.all(color:color,width:2),
    ),
    child:Row(
      children:[
        Text(emoji,style:const TextStyle(fontSize:32)),
        const SizedBox(width:12),
        Expanded(child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            Text(title,style:TextStyle(fontSize:16,fontWeight:FontWeight.bold,color:color)),
            Text(subtitle,style:TextStyle(fontSize:12,color:color.withValues(alpha:0.7))),
          ],
        )),
      ],
    ),
  );
}

class _Trail extends StatelessWidget {
  const _Trail(this.world);
  final int world;
  static double pathX(int i,int w)=>sin(i*.88+w*.3)*.62;
  @override Widget build(BuildContext context){
    final g=GameScope.of(context);
    final color=worldColors[world];
    return Sky(title:'${worldEmojis[world]} ${worlds[world]}',world:world,child:SingleChildScrollView(
      padding:const EdgeInsets.all(14),
      child:CustomPaint(
        painter:_FantasyPath(color),
        child:Column(children:[
          for(var i=0;i<10;i++)
            SizedBox(height:100,child:Align(alignment:Alignment(pathX(i,world),0),child:_LevelNode(
              world:world,level:i,color:color,stars:g.p.stars['$world:$i']??0,
              onTap:g.locked?null:()=>go(context,LevelScreen(world,i,Mode.story)),
            ))),
        ]),
      ),
    ));
  }
}

class _LevelNode extends StatelessWidget {
  final int world, level;
  final Color color;
  final int stars;
  final VoidCallback? onTap;
  const _LevelNode({required this.world,required this.level,required this.color,required this.stars,required this.onTap});
  @override Widget build(BuildContext context)=>SizedBox(width:150,child:GestureDetector(
    onTap:onTap,
    child:Container(
      padding:const EdgeInsets.symmetric(vertical:10,horizontal:14),
      decoration:BoxDecoration(
        gradient:LinearGradient(colors:[color.withValues(alpha:0.9),color.withValues(alpha:0.65)]),
        borderRadius:BorderRadius.circular(20),
        border:Border.all(color:Colors.white,width:2.5),
        boxShadow:[
          BoxShadow(color:color.withValues(alpha:0.4),offset:const Offset(0,5),blurRadius:10),
          BoxShadow(color:Colors.white.withValues(alpha:0.2),offset:const Offset(0,2),blurRadius:4),
        ],
      ),
      child:Column(
        mainAxisSize:MainAxisSize.min,
        children:[
          Text(worldEmojis[world],style:const TextStyle(fontSize:20)),
          Text('مرحله ${fa(level+1)}',style:const TextStyle(fontSize:16,fontWeight:FontWeight.bold,color:Colors.white)),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children:List.generate(3,(s)=>Padding(
              padding:const EdgeInsets.symmetric(horizontal:1),
              child:Icon(s<stars?Icons.star:Icons.star_border,color:const Color(0xFFFFD93D),size:16),
            )),
          ),
        ],
      ),
    ),
  ));
}

class _FantasyPath extends CustomPainter {
  _FantasyPath(this.color);
  final Color color;
  @override void paint(Canvas canvas,Size size){
    final p=Path();
    Offset pt(int i)=>Offset(size.width/2+_Trail.pathX(i,world)*(size.width-150)/2,50.0+i*100);
    p.moveTo(pt(0).dx,pt(0).dy);
    for(var i=1;i<10;i++){
      final a=pt(i-1),b=pt(i);
      p.cubicTo(a.dx,a.dy+50,b.dx,b.dy-50,b.dx,b.dy);
    }
    // هالهٔ نور بزرگ
    for(final m in p.computeMetrics()){
      for(double d=0;d<m.length;d+=8){
        final pos=m.getTangentForOffset(d)!.position;
        canvas.drawCircle(pos,10,Paint()..color=color.withValues(alpha:0.08)..maskFilter=const MaskFilter.blur(BlurStyle.normal,8));
        canvas.drawCircle(pos,5,Paint()..color=color.withValues(alpha:0.15)..maskFilter=const MaskFilter.blur(BlurStyle.normal,3));
        canvas.drawCircle(pos,2.5,Paint()..color=color.withValues(alpha:0.6));
      }
      // ستاره‌های درخشان روی مسیر
      for(double d=15;d<m.length;d+=40){
        final pos=m.getTangentForOffset(d)!.position;
        canvas.drawCircle(pos,1.5,Paint()..color=Colors.white.withValues(alpha:0.8));
      }
    }
  }
  @override bool shouldRepaint(covariant _FantasyPath old)=>old.color!=color;
}
