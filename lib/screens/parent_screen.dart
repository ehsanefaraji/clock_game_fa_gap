import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/question.dart';
import '../models/world.dart';
import '../theme/app_theme.dart';
Future<void> parentGate(BuildContext context) async {
  final a=13+Random().nextInt(46),b=19+Random().nextInt(37);
  String input='';
  final ok=await showDialog<bool>(context:context,builder:(context)=>AlertDialog(title:const Text('ورود والدین'),content:TextField(autofocus:true,keyboardType:TextInputType.number,onChanged:(s)=>input=s,decoration:InputDecoration(labelText:'${fa(a)} به‌علاوهٔ ${fa(b)} چند می‌شود؟')),actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('بازگشت')),TextButton(onPressed:()=>Navigator.pop(context,fa(input.trim()).replaceAllMapped(RegExp('[٠-٩]'),(m)=>'۰۱۲۳۴۵۶۷۸۹'[m[0]!.codeUnitAt(0)-0x660])==fa(a+b)),child:const Text('ورود'))]));
  if(!context.mounted)return;
  if(ok==true){await go(context,const ParentScreen());}else if(ok==false && input.trim().isNotEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('پاسخ درست نبود. دوباره تلاش کنید.')));}
}
class ParentScreen extends StatelessWidget {
  const ParentScreen({super.key});
  @override Widget build(BuildContext context){final g=GameScope.of(context), p=g.p;return Sky(title:'حالت والدین',child:Pad(children:[Text('زمان استفادهٔ امروز: ${fa(g.store.seconds~/60)} دقیقه و ${fa(g.store.seconds%60)} ثانیه'),Text('کل ستاره‌ها: ${fa(p.total)} از ۱۵۰'),for(var w=0;w<5;w++)Text('${worlds[w]}: ${fa(List.generate(10,(l)=>p.stars['$w:$l']??0).where((s)=>s==3).length)} مرحلهٔ سه‌ستاره از ۱۰'),const Text('محدودیت روزانه'),DropdownButton<int>(value:p.limit,isExpanded:true,items:[for(final t in [0,5,10,15,20,30,45,60])DropdownMenuItem(value:t,child:Text(t==0?'بدون محدودیت':'${fa(t)} دقیقه'))],onChanged:(t){p.limit=t??0;g.save();g.audio.music(p.music&&!g.locked);}),SwitchListTile(title:const Text('موسیقی'),value:p.music,onChanged:(v){p.music=v;g.save();g.audio.music(v&&!g.locked);}),SwitchListTile(title:const Text('گویندهٔ فارسی'),value:p.voice,onChanged:(v){p.voice=v;g.save();if(!v)g.tts.stop();}),SwitchListTile(title:const Text('صداهای بازی'),value:p.effects,onChanged:(v){p.effects=v;g.save();}),PlayButton('آزمایش صدای فارسی',() async {final ok=p.voice&&await g.tts.say('سلام! من جغد ساعت هستم.');if(context.mounted&&!ok)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('گوینده خاموش است یا موتور گفتار فارسی روی دستگاه در دسترس نیست.')));}),const Text('اطلاعات روی همین دستگاه ذخیره می‌شود. برنامه حساب کاربری، تبلیغ یا خرید پولی ندارد. موتور گفتار تابع تنظیمات دستگاه است.') ]));}
}
