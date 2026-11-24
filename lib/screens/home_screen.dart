import 'package:flutter/material.dart';
import '../main.dart';
import '../models/question.dart';
import '../models/world.dart';
import '../theme/app_theme.dart';
import '../widgets/owl_character.dart';
import 'level_screen.dart';
import 'parent_screen.dart';
import 'shop_screen.dart';
import 'world_map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context){final g=GameScope.of(context);void play(Widget page){g.audio.music(g.p.music);go(context,page);}return Sky(title:'ساعت بازی 🕐',child:Pad(children:[Owl(size:205,wearing:g.p.wearing),Text('سلام! من جغد ساعت هستم.',textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleLarge),Text(g.locked?'زمان بازی امروز تمام شد.':'با هم عقربه‌ها را کشف کنیم!',textAlign:TextAlign.center),Text('★ ${fa(g.p.total)} ستاره   •   ${fa(g.p.balance)} سکه',textAlign:TextAlign.center),PlayButton('نقشهٔ دنیاها',g.locked?null:()=>play(const WorldMapScreen()),color:const Color(0xFFFFA864)),PlayButton('تمرین آزاد',g.locked?null:()=>play(const PracticeMenu()),color:const Color(0xFFA0EFCF)),PlayButton('چالش روزانه',g.locked?null:()=>play(const LevelScreen(4,1,Mode.daily))),PlayButton('حالت دو نفره',g.locked?null:()=>play(const LevelScreen(2,1,Mode.duo)),color:const Color(0xFFBDEFFF)),PlayButton('فروشگاه جغد',g.locked?null:()=>play(const ShopScreen()),color:const Color(0xFFFFC5D6)),PlayButton('حالت والدین',()=>parentGate(context),color:paper)]));}
}
class PracticeMenu extends StatelessWidget {
  const PracticeMenu({super.key});
  @override Widget build(BuildContext context){final locked=GameScope.of(context).locked;return Sky(title:'تمرین آزاد',child:Pad(children:[const Text('کدام بخش را تمرین کنیم؟'),for(var i=0;i<worlds.length;i++)PlayButton(worlds[i],locked?null:()=>go(context,LevelScreen(i,4,Mode.practice)),color:Color.alphaBlend(worldColors[i].withAlpha(90),paper))]));}
}
