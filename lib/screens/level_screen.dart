import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/question.dart';
import '../models/world.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/owl_character.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/star_rating.dart';
import '../widgets/analog_clock.dart';
import 'read_clock_screen.dart';
import 'set_clock_screen.dart';
import 'time_math_screen.dart';

enum Mode { story, practice, daily, duo }
class LevelScreen extends StatefulWidget {
  const LevelScreen(this.world,this.level,this.mode,{super.key});
  final int world,level;
  final Mode mode;
  @override State<LevelScreen> createState()=>_LevelScreenState();
}
class _LevelScreenState extends State<LevelScreen> with SingleTickerProviderStateMixin {
  late final bool daily=widget.mode==Mode.daily,duo=widget.mode==Mode.duo,story=widget.mode==Mode.story;
  late final questions=Question.make(widget.world,widget.level,daily?3:duo?6:5,daily?Random(int.parse(ProgressService.day().replaceAll('-',''))):Random());
  late final AnimationController motion=AnimationController(vsync:this,duration:const Duration(milliseconds:360));
  final points=[0,0];
  final scroll=ScrollController();
  late GameData game;
  Timer? timer;
  Stopwatch watch=Stopwatch();
  int index=0,mistakes=0,seconds=30,stars=0;
  bool started=false,won=false,wrong=false,done=false,expired=false,voiceMissing=false;
  String get title=>story?'مرحلهٔ ${fa(widget.level+1)}':switch(widget.mode){Mode.practice=>'تمرین آزاد',Mode.daily=>'چالش روزانه',_=>'حالت دو نفره'};
  Question get q=>questions[index];
  String minutes(int d)=>d==60?'شصت':d==75?'هفتاد و پنج':minuteWords[d~/5];
  String get prompt=>switch(q.task){Task.read=>'ساعت چند است؟',Task.set=>'ساعت را روی «${words(q.answer)}» بگذار.',Task.math=>'الان ${words(q.start)} است. ${minutes(q.delta)} دقیقه بعد ساعت چند است؟'};
  @override void initState(){super.initState();game=GameScope.read(context);WidgetsBinding.instance.addPostFrameCallback((_){if(mounted&&!game.locked)unawaited(game.say(story?lessons[widget.world]:intro));});}
  String get intro=>daily?'سه پرسش در سی ثانیه؛ آماده‌ای؟':duo?'یکی از شما سارا و دیگری آراد باشد. به نوبت بازی کنید.':'بدون زمان‌سنج، با ساعت بازی کن.';
  void start(){setState(()=>started=true);if(daily){watch.start();timer=Timer.periodic(const Duration(milliseconds:120),(_){if(!mounted||done)return;final left=max(0,30-watch.elapsedMilliseconds~/1000);if(left==0){finish(timeout:!won || index!=questions.length-1);}else if(left!=seconds)setState(()=>seconds=left);});}unawaited(game.say(prompt));}
  void answer(int t){if(won||done||game.locked)return;final right=t==q.answer;setState((){wrong=!right;won=right;if(!right)mistakes++;if(duo&&right)points[index%2]++;});if(story){game.p.coins+=right?10:2;game.save();}if(!MediaQuery.of(context).disableAnimations)motion.forward(from:0);unawaited(right?HapticFeedback.lightImpact():HapticFeedback.mediumImpact());if(game.p.effects)unawaited(game.audio.play(right?'ding':'boop'));unawaited(game.say(right?'آفرین! ${words(q.answer)}.':'دوباره تلاش کن!'));if(right&&index==questions.length-1)timer?.cancel();
    // اتوماتیک به پرسش بعدی برو بعد از پاسخ درست
    if(right){Future.delayed(const Duration(milliseconds:2000),(){if(mounted&&!done)next();});}}
  void finish({bool timeout=false}){if(done||game.locked)return;timer?.cancel();watch.stop();stars=timeout?0:mistakes==0?3:mistakes<=2?2:1;if(story&&!timeout){final k='${widget.world}:${widget.level}';game.p.stars[k]=max(game.p.stars[k]??0,stars);game.save();}if(daily&&!timeout&&game.p.daily!=ProgressService.day()){game.p.daily=ProgressService.day();game.p.coins+=30;game.save();}setState((){expired=timeout;done=true;});if(scroll.hasClients)scroll.jumpTo(0);if(!timeout){unawaited(HapticFeedback.heavyImpact());if(game.p.effects)unawaited(game.audio.play('tada'));unawaited(game.say('آفرین! بازی را تمام کردی.'));}}
  Future<void> repeatVoice(String text) async {if(!game.p.voice){setState(()=>voiceMissing=true);return;}final ok=await game.tts.say(text);if(mounted)setState(()=>voiceMissing=!ok);}
  @override void dispose(){timer?.cancel();watch.stop();unawaited(game.tts.stop());motion.dispose();scroll.dispose();super.dispose();}
  @override Widget build(BuildContext context){final g=GameScope.of(context);if(g.locked)return Sky(title:title,child:const Pad(children:[Text('زمان بازی امروز تمام شد. فردا دوباره می‌بینمت!')]));
    if(!started)return Sky(title:title,child:Pad(children:[Owl(mood:OwlMood.curious,wearing:g.p.wearing),Text(story?lessons[widget.world]:intro,textAlign:TextAlign.center),if(story)AnalogClock(time:180+[0,30,15,10,55][widget.world],reveal:true),PlayButton('شروع بازی',start),PlayButton('شنیدن راهنما',()=>repeatVoice(story?lessons[widget.world]:intro),color:paper),if(voiceMissing)const Text('صدای فارسی دستگاه در دسترس نیست یا در تنظیمات خاموش است.')]));
    if(done)return Sky(title:title,child:Stack(children:[Pad(children:[Owl(size:175,mood:expired?OwlMood.encouraging:OwlMood.celebrating,wearing:g.p.wearing),Text(expired?'زمان تمام شد؛ باز هم می‌توانی تمرین کنی!':story&&widget.level==9&&stars==3?'آفرین! این دنیا را کامل کردی!':'آفرین! بازی را تمام کردی!',textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleLarge),if(story)StarRating(stars),if(story&&stars<3)const Text('برای باز شدن مرحلهٔ بعد، همین مرحله را بدون اشتباه کامل کن.'),if(duo)Text('سارا: ${fa(points[0])} پاسخ درست؛ آراد: ${fa(points[1])} پاسخ درست.'),if(daily&&!expired)const Text('جایزهٔ ویژهٔ امروز: ۳۰ سکه، فقط یک بار در روز.'),PlayButton('بازگشت',()=>Navigator.pop(context))]),if(!expired)const Positioned.fill(child:ConfettiOverlay())]));
    final callback=won?null:answer;
    return Sky(title:title,child:Stack(children:[ListView(controller:scroll,padding:const EdgeInsets.fromLTRB(18,8,18,24),children:[LinearProgressIndicator(value:(index+(won?1:0))/questions.length,semanticsLabel:'پیشرفت بازی',semanticsValue:'${fa(index+(won?1:0))} از ${fa(questions.length)}',minHeight:10,borderRadius:BorderRadius.circular(12)),const SizedBox(height:8),Text('پرسش ${fa(index+1)} از ${fa(questions.length)}${daily?' • ${fa(seconds)} ثانیه':''}${duo?' • نوبت ${index.isEven?'سارا':'آراد'}':''}',textAlign:TextAlign.center),Owl(size:88,wearing:g.p.wearing,mood:won?OwlMood.celebrating:wrong?OwlMood.encouraging:OwlMood.thinking),AnimatedBuilder(animation:motion,child:Semantics(liveRegion:true,child:Text(won?'✅ آفرین! پاسخ درست! برو بعدی...':wrong?'❌ تقریباً درست بود! دوباره فکر کن و امتحان کن.':prompt,textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleLarge)),builder:(context,child)=>Transform.translate(offset:Offset(wrong?sin(motion.value*pi*6)*6*(1-motion.value):0,won?-8*sin(motion.value*pi):0),child:child)),if(won)SizedBox(height:8),KeyedSubtree(key:ValueKey(index),child:switch(q.task){Task.read=>ReadClockScreen(q,callback),Task.set=>SetClockScreen(callback),Task.math=>TimeMathScreen(q,callback)}),const SizedBox(height:12),PlayButton('شنیدن پرسش',()=>repeatVoice(prompt),color:paper),if(voiceMissing)const Text('صدای فارسی دستگاه در دسترس نیست یا در تنظیمات خاموش است.')]),if(won)Positioned.fill(child:ConfettiOverlay(key:ValueKey(index)))]));
  }
}
