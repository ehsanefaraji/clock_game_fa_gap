import 'package:flutter/material.dart';
import '../main.dart';
import '../models/question.dart';
import '../models/world.dart';
import '../theme/app_theme.dart';
import 'level_screen.dart';
import 'parent_screen.dart';
import 'shop_screen.dart';
import 'world_map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final g = GameScope.of(context);
    void play(Widget page) { g.audio.music(g.p.music); go(context, page); }
    VoidCallback? launch(Widget page) => g.locked ? null : () => play(page);
    return Sky(title: 'بازی با ساعت', child: Pad(children: [
      Container(decoration: BoxDecoration(color: paper, borderRadius: BorderRadius.circular(26), border: Border.all(color: const Color(0xFFB27B44), width: 2), boxShadow: const [BoxShadow(color: Color(0x453A3021), blurRadius: 12, offset: Offset(0, 5))]),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          Image.asset('assets/images/tiko_cover.png', width: double.infinity, fit: BoxFit.fitWidth, semanticLabel: 'تیکو یک ساعت طلایی در آغوش دارد'),
          Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 16), child: Column(children: [
            const Text('تیکو، جغد ساعت‌ساز', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lalezar', color: Color(0xFF16494D), fontSize: 32, height: 1.15)),
            Text(g.locked ? 'زمان بازی امروز تمام شد.' : 'آماده‌ای با هم عقربه‌ها را کشف کنیم؟', textAlign: TextAlign.center, style: const TextStyle(color: ink, fontSize: 19, fontWeight: FontWeight.bold)),
          ])),
        ]),
      ),
      PlayButton(g.p.total == 0 ? 'شروع ماجراجویی' : 'ادامهٔ بازی', launch(LevelScreen(g.p.lastWorld, g.p.nextStoryLevel, Mode.story)), color: const Color(0xFFFFC76C)),
      Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [
        _Counter(Icons.star_rounded, '${fa(g.p.total)} ستاره'),
        _Counter(Icons.toll_rounded, '${fa(g.p.balance)} سکه'),
      ]),
      _TikoBag(earned: [for (var i = 0; i < worlds.length; i++) g.p.completedWorld(i)]),
      const Text('کجا برویم؟', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lalezar', color: ink, fontSize: 28)),
      _HomeLink(Icons.auto_awesome_rounded, 'نقشهٔ دنیاها', 'از مسیر ستاره‌ها به سرزمین‌های تیکو برو', const Color(0xFFD9F2E8), launch(const WorldMapScreen())),
      _HomeLink(Icons.bolt_rounded, 'چالش روزانه', 'مسابقه با زمان', const Color(0xFFFFEDC8), launch(const LevelScreen(4,1,Mode.daily))),
      _HomeLink(Icons.people_alt_rounded, 'بازی دو نفره', 'با یک دوست بازی کن', const Color(0xFFE2F3F9), launch(const LevelScreen(2,1,Mode.duo))),
      _HomeLink(Icons.storefront_rounded, 'فروشگاه تیکو', 'لباس‌ها و وسایل جغد', const Color(0xFFFFE6D9), launch(const ShopScreen())),
      _HomeLink(Icons.family_restroom_rounded, 'بخش والدین', 'تنظیمات و پیشرفت', paper, () => parentGate(context)),
    ]));
  }
}

class _Counter extends StatelessWidget {
  const _Counter(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: paper, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFAD713D))),
    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: Row(mainAxisSize: MainAxisSize.min, children: [
      Stack(alignment: Alignment.center, children: [Icon(icon, size: 27, color: const Color(0xFF804A21)), Icon(icon, size: 22, color: const Color(0xFFF6AD3C))]),
      const SizedBox(width: 5), Text(label, style: const TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.bold)),
    ])),
  );
}

class _TikoBag extends StatelessWidget {
  const _TikoBag({required this.earned});
  final List<bool> earned;
  static const icons = [Icons.eco_rounded, Icons.cloud_rounded, Icons.castle_rounded, Icons.settings_rounded, Icons.schedule_rounded];
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFFFFE8C4), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFB47E50), width: 2)),
    child: Column(children: [
      const Text('کیف نشان‌های تیکو', style: TextStyle(fontFamily: 'Lalezar', color: ink, fontSize: 25)),
      const Text('همهٔ مرحله‌های هر دنیا را تمام کن تا نشانش به کیف اضافه شود.', textAlign: TextAlign.center, style: TextStyle(color: ink, fontSize: 16)),
      const SizedBox(height: 9),
      Wrap(alignment: WrapAlignment.center, spacing: 7, runSpacing: 7, children: [
        for (var i = 0; i < earned.length; i++) Tooltip(message: '${worlds[i]}؛ ${earned[i] ? 'گرفته شد' : 'هنوز به‌دست نیامده'}', child: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(shape: BoxShape.circle, color: earned[i] ? const Color(0xFFFCBF60) : const Color(0xFFF2D5AE), border: Border.all(color: earned[i] ? const Color(0xFF874821) : const Color(0xFF956F53), width: 2)),
          child: Icon(earned[i] ? icons[i] : Icons.lock_outline_rounded, color: ink, size: 24),
        )),
      ]),
    ]),
  );
}

class _HomeLink extends StatelessWidget {
  const _HomeLink(this.icon, this.title, this.subtitle, this.color, this.action);
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Material(
    color: action == null ? const Color(0xFFEDE3D5) : color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFB38660))),
    clipBehavior: Clip.antiAlias,
    child: InkWell(onTap: action, child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
      CircleAvatar(radius: 24, backgroundColor: paper, foregroundColor: const Color(0xFF194F53), child: Icon(icon, size: 25)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontFamily: 'Lalezar', fontSize: 25, color: ink, height: 1.15)),
        Text(subtitle, style: const TextStyle(fontSize: 16, color: ink, height: 1.4)),
      ])),
      Icon(action == null ? Icons.lock_outline : Icons.chevron_left_rounded, color: ink),
    ]))),
  );
}
class PracticeMenu extends StatelessWidget {
  const PracticeMenu({super.key});
  @override Widget build(BuildContext context){final locked=GameScope.of(context).locked;return Sky(title:'تمرین آزاد',child:Pad(children:[const Text('کدام بخش را تمرین کنیم؟'),for(var i=0;i<worlds.length;i++)PlayButton(worlds[i],locked?null:()=>go(context,TaskTypeMenu(world:i,title:worlds[i])),color:Color.alphaBlend(worldColors[i].withAlpha(90),paper))]));}
}
/// منوی انتخاب نوع تمرین: خواندن، تنظیم، یا محاسبه
class TaskTypeMenu extends StatelessWidget {
  const TaskTypeMenu({super.key,required this.world,this.taskFilter,this.title});
  final int world;
  final Task? taskFilter;
  final String? title;
  @override Widget build(BuildContext context){
    final locked=GameScope.of(context).locked;
    return Sky(title:title??'انتخاب تمرین',child:Pad(children:[
      const Text('چه نوع تمرینی می‌خواهی؟',textAlign:TextAlign.center,style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      const SizedBox(height:8),
      PlayButton('📚 خواندن ساعت\nنمایش ساعت + ۴ گزینه',locked?null:()=>go(context,LevelScreen(world,4,Mode.practice,taskFilter:Task.read)),color:const Color(0xFF74B9FF)),
      PlayButton('🔧 تنظیم ساعت\nزمان را بگو، عقربه را بچرخان',locked?null:()=>go(context,LevelScreen(world,4,Mode.practice,taskFilter:Task.set)),color:const Color(0xFFE17055)),
      PlayButton('🎲 محاسبه زمان\nچند دقیقه بعد/قبل؟',locked?null:()=>go(context,LevelScreen(world,4,Mode.practice,taskFilter:Task.math)),color:const Color(0xFFFD79A8)),
      PlayButton('🎲 ترکیبی\nهمه نوع سؤال‌ها',locked?null:()=>go(context,LevelScreen(world,4,Mode.practice)),color:const Color(0xFF55EFC4)),
    ]));
  }
}
