import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/question.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/owl_character.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/star_rating.dart';
import 'read_clock_screen.dart';

enum Mode { story, practice, daily, duo }
class LevelScreen extends StatefulWidget {
  const LevelScreen(this.world,this.level,this.mode,{super.key,this.taskFilter});
  final int world,level;
  final Mode mode;
  final Task? taskFilter;
  @override State<LevelScreen> createState()=>_LevelScreenState();
}
class _LevelScreenState extends State<LevelScreen> with SingleTickerProviderStateMixin {
  late final bool daily=widget.mode==Mode.daily,duo=widget.mode==Mode.duo,story=widget.mode==Mode.story;
  late final questions=story?Question.story(widget.world,widget.level,Random()):Question.make(widget.world,widget.level,daily?3:duo?6:5,daily?Random(int.parse(ProgressService.day().replaceAll('-',''))):Random(),taskFilter:widget.taskFilter);
  late final AnimationController motion=AnimationController(vsync:this,duration:const Duration(milliseconds:360));
  final points=[0,0];
  final scroll=ScrollController();
  late GameData game;
  Timer? timer;
  Stopwatch watch=Stopwatch();
  int index=0,mistakes=0,seconds=30,stars=0;
  bool started=false,won=false,wrong=false,done=false,expired=false;
  String get title=>story?'مرحلهٔ ${fa(widget.level+1)}':switch(widget.mode){Mode.practice=>'تمرین آزاد',Mode.daily=>'چالش روزانه',_=>'حالت دو نفره'};
  Question get q=>questions[index];
  String minutes(int d)=>d==60?'شصت':d==75?'هفتاد و پنج':minuteWords[d~/5];
  String get prompt=>switch(q.task){Task.read=>'ساعت چند است؟',Task.set=>'ساعت را روی «${words(q.answer)}» بگذار.',Task.math=>'الان ${words(q.start)} است. ${minutes(q.delta)} دقیقه بعد ساعت چند است؟'};
  String hint = '';
  @override void initState(){
    super.initState();
    game=GameScope.read(context);
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(!mounted||game.locked)return;
      if(story){game.p.lastWorld=widget.world; game.save(); start();}
    });
  }
  String get intro=>daily?'سه پرسش در سی ثانیه؛ آماده‌ای؟':duo?'یکی از شما سارا و دیگری آراد باشد. به نوبت بازی کنید.':'بدون زمان‌سنج، با ساعت بازی کن.';
  void start(){setState(()=>started=true);if(daily){watch.start();timer=Timer.periodic(const Duration(milliseconds:120),(_){if(!mounted||done)return;final left=max(0,30-watch.elapsedMilliseconds~/1000);if(left==0){finish(timeout:!won || index!=questions.length-1);}else if(left!=seconds)setState(()=>seconds=left);});}}
  String feedback(int t) {
    if(q.task==Task.math)return 'از ساعت شروع کن و عقربهٔ بلند را به اندازهٔ دقیقه‌های خواسته‌شده جلو ببر.';
    if(t~/60==q.answer~/60)return 'ساعت را درست خواندی؛ دوباره به عقربهٔ بلند نگاه کن.';
    if(t%60==q.answer%60)return 'دقیقه درست است؛ دوباره به عقربهٔ کوتاه نگاه کن.';
    return 'اول عقربهٔ کوتاه و بعد عقربهٔ بلند را نگاه کن.';
  }
  void answer(int t){
    if(won||done||game.locked)return;
    final right=t==q.answer;
    setState((){wrong=!right;won=right;hint=right?'':feedback(t);if(!right)mistakes++;if(duo&&right)points[index%2]++;});
    if(story){game.p.coins+=right?10:2;game.save();}
    if(!MediaQuery.of(context).disableAnimations)motion.forward(from:0);
    unawaited(right?HapticFeedback.lightImpact():HapticFeedback.mediumImpact());
    if(game.p.effects)unawaited(game.audio.play(right?'ding':'boop'));
    if(right&&index==questions.length-1)timer?.cancel();
    if(right)Future<void>.delayed(Duration(milliseconds:daily?500:1400),(){if(mounted&&!done&&!game.locked)next();});
  }
  void next(){if(index==questions.length-1){finish();return;}setState((){index++;won=false;wrong=false;});if(scroll.hasClients)scroll.jumpTo(0);}
  void finish({bool timeout=false}){if(done||game.locked)return;timer?.cancel();watch.stop();stars=timeout?0:mistakes==0?3:mistakes<=2?2:1;if(story&&!timeout){final k='${widget.world}:${widget.level}';game.p.stars[k]=max(game.p.stars[k]??0,stars);game.save();}if(daily&&!timeout&&game.p.daily!=ProgressService.day()){game.p.daily=ProgressService.day();game.p.coins+=30;game.save();}setState((){expired=timeout;done=true;});if(scroll.hasClients)scroll.jumpTo(0);if(!timeout){unawaited(HapticFeedback.heavyImpact());if(game.p.effects)unawaited(game.audio.play('tada'));}}
  @override void dispose(){timer?.cancel();watch.stop();motion.dispose();scroll.dispose();super.dispose();}
  @override Widget build(BuildContext context){final g=GameScope.of(context);if(g.locked)return Sky(title:title,world:widget.world,child:const Pad(children:[Text('زمان بازی امروز تمام شد. فردا دوباره می‌بینمت!')]));
    if(!started)return Sky(title:title,world:widget.world,child:story?const SizedBox.shrink():Pad(children:[Owl(mood:OwlMood.curious,wearing:g.p.wearing),Text(intro,textAlign:TextAlign.center),PlayButton('شروع بازی',start)]));
    if(done)return Sky(title:title,world:widget.world,child:Stack(children:[Pad(children:[Owl(size:150,mood:expired?OwlMood.encouraging:OwlMood.celebrating,wearing:g.p.wearing),Card(color:paper,child:Padding(padding:const EdgeInsets.all(16),child:Column(children:[
      Text(expired?'زمان تمام شد؛ باز هم می‌توانی تمرین کنی!':'آفرین! بازی را تمام کردی!',textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleLarge),
      if(story)StarRating(stars),
      if(story&&stars<3)const Text('برای گرفتن هر سه ستاره، مرحله را بدون اشتباه کامل کن.'),
      if(duo)Text('سارا: ${fa(points[0])} پاسخ درست؛ آراد: ${fa(points[1])} پاسخ درست.'),
      if(daily&&!expired)const Text('جایزهٔ ویژهٔ امروز: ۳۰ سکه، فقط یک بار در روز.'),
    ]))),PlayButton('بازگشت',()=>Navigator.pop(context))]),if(!expired&&!MediaQuery.of(context).disableAnimations)const Positioned.fill(child:IgnorePointer(child:ConfettiOverlay()))]));
    final callback=won?null:answer;
    return Sky(title:title,world:widget.world,child:ListView(controller:scroll,padding:const EdgeInsets.fromLTRB(12,4,12,16),children:[
      Container(decoration:BoxDecoration(color:const Color(0xFFFFF5DB),borderRadius:BorderRadius.circular(23),border:Border.all(color:const Color(0xFFAA7036),width:2),boxShadow:const [BoxShadow(color:Color(0x50362B20),blurRadius:8,offset:Offset(0,3))]),child:Padding(padding:const EdgeInsets.fromLTRB(10,9,10,9),child:Column(children:[
        Row(children:[
          for(var i=0;i<questions.length;i++) Expanded(child:Icon(
            i<index || i==index&&won ? Icons.star_rounded : i==index ? Icons.auto_awesome_rounded : Icons.star_border_rounded,
            semanticLabel: i==index ? 'پرسش فعلی' : null,
            color: i<=index ? const Color(0xFF995720) : const Color(0xFF977A60),
            size:22,
          )),
        ]),
        const SizedBox(height:6),
        Row(children:[
          Owl(size:50,wearing:g.p.wearing,mood:won?OwlMood.happy:wrong?OwlMood.encouraging:OwlMood.thinking),
          const SizedBox(width:6),
          Expanded(child:Text(switch(q.task){Task.read=>'کارآگاهِ عقربه‌ها',Task.set=>'ساعت‌سازِ کوچولو',Task.math=>'معمای زمان'},style:const TextStyle(fontFamily:'Lalezar',fontSize:23,color:Color(0xFF174A4F)))),
          const Icon(Icons.auto_awesome_rounded,color:Color(0xFF995720)),
        ]),
        Text('پرسش ${fa(index+1)} از ${fa(questions.length)}${daily?' • ${fa(seconds)} ثانیه':''}${duo?' • نوبت ${index.isEven?'سارا':'آراد'}':''}',textAlign:TextAlign.center,style:const TextStyle(fontSize:15,color:ink,fontWeight:FontWeight.bold)),
        const SizedBox(height:5),
        Container(width:double.infinity,padding:const EdgeInsets.symmetric(horizontal:10,vertical:7),decoration:BoxDecoration(color:const Color(0xFFFFEBC0),borderRadius:const BorderRadiusDirectional.only(topStart:Radius.circular(5),topEnd:Radius.circular(18),bottomStart:Radius.circular(18),bottomEnd:Radius.circular(18)),border:Border.all(color:const Color(0xFFBE874A))),child:Text(prompt,textAlign:TextAlign.center,style:const TextStyle(fontFamily:'Vazirmatn',fontSize:24,color:ink,fontWeight:FontWeight.bold,height:1.4))),
        if(won||wrong) AnimatedBuilder(animation:motion,builder:(context,child)=>Transform.translate(offset:Offset(wrong?sin(motion.value*pi*6)*4*(1-motion.value):0,0),child:child),child:Semantics(liveRegion:true,child:Text(won?'✓ آفرین! پاسخ درست!':hint,textAlign:TextAlign.center,style:TextStyle(fontSize:17,fontWeight:FontWeight.bold,color:won?const Color(0xFF246839):const Color(0xFF8A431F))))),
      ]))),
      const SizedBox(height:8),
      KeyedSubtree(key:ValueKey(index),child:switch(q.task){Task.read=>ReadClockScreen(q,callback),Task.set=>SetClockScreen(callback,target:q.answer),Task.math=>TimeMathScreen(q,callback)}),
    ]));
  }
}
