import 'package:flutter/material.dart';
import '../main.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../widgets/owl_character.dart';
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});
  static const items={'hat':('کلاه آبی',60),'glasses':('عینک گرد',90),'badge':('رنگ صورتی برای پرهای سینه',120)};
  @override Widget build(BuildContext context){final g=GameScope.of(context);final p=g.p;return Sky(title:'فروشگاه جغد',child:Pad(children:[Owl(size:192,wearing:p.wearing),Text('کیف تو: ${fa(p.balance)} سکه',textAlign:TextAlign.center),const Text('اینجا فقط با سکه‌های بازی خرید می‌کنی.'),for(final e in items.entries)PlayButton('${e.value.$1} • ${p.wearing==e.key?'پوشیده شده':p.owned.contains(e.key)?'بپوشان':'${fa(e.value.$2)} سکه'}',g.locked||p.wearing==e.key||!p.owned.contains(e.key)&&p.balance<e.value.$2?null:(){if(p.owned.add(e.key)){p.spent+=e.value.$2;}p.wearing=e.key;g.save();if(p.effects)g.audio.play('ding');}),PlayButton('بدون پوشیدنی',g.locked||p.wearing.isEmpty?null:(){p.wearing='';g.save();},color:paper)]));}
}
