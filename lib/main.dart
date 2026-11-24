import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/player_progress.dart';
import 'screens/home_screen.dart';
import 'services/audio_service.dart';
import 'services/progress_service.dart';
import 'services/tts_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ClockApp(ProgressService(await SharedPreferences.getInstance())));
}
class GameData extends ChangeNotifier {
  GameData(this.store):p=store.load();
  final ProgressService store;
  final PlayerProgress p;
  final audio=AudioService();
  final tts=TtsService();
  bool get locked=>p.limit>0 && store.seconds>=p.limit*60;
  void save(){unawaited(store.save(p));notifyListeners();}
  void refresh()=>notifyListeners();
  Future<void> say(String line) async {if(p.voice){await tts.say(line);}}
}
class GameScope extends InheritedNotifier<GameData> {
  const GameScope(GameData data,{super.key,required super.child}):super(notifier:data);
  static GameData of(BuildContext context)=>context.dependOnInheritedWidgetOfExactType<GameScope>()!.notifier!;
  static GameData read(BuildContext context)=>(context.getElementForInheritedWidgetOfExactType<GameScope>()!.widget as GameScope).notifier!;
}
class ClockApp extends StatefulWidget {
  const ClockApp(this.store,{super.key});
  final ProgressService store;
  @override State<ClockApp> createState()=>_ClockAppState();
}
class _ClockAppState extends State<ClockApp> with WidgetsBindingObserver {
  late final GameData data=GameData(widget.store);
  late final Timer timer;
  bool active=true;
  String day=ProgressService.day();
  @override void initState(){super.initState();WidgetsBinding.instance.addObserver(this);timer=Timer.periodic(const Duration(seconds:1),(_){if(!active)return;final now=ProgressService.day();if(now!=day){day=now;data.refresh();}if(!data.locked){unawaited(data.store.tick());if(data.locked){unawaited(data.tts.stop());unawaited(data.audio.music(false));}data.refresh();}});}
  @override void didChangeAppLifecycleState(AppLifecycleState state){active=state==AppLifecycleState.resumed;unawaited(data.audio.music(active && data.p.music && !data.locked));if(!active)unawaited(data.tts.stop());}
  @override void dispose(){timer.cancel();WidgetsBinding.instance.removeObserver(this);data.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>GameScope(data,child:MaterialApp(title:'ساعت بازی',debugShowCheckedModeBanner:false,locale:const Locale('fa','IR'),supportedLocales:const [Locale('fa','IR')],localizationsDelegates:GlobalMaterialLocalizations.delegates,theme:theme(),builder:(context,child)=>Directionality(textDirection:TextDirection.rtl,child:child!),home:const HomeScreen()));
}
