import 'package:flutter/material.dart';
const ink = Color(0xFF3D2C1E);
const paper = Color(0xFFFFFAEE);
const magicPurple = Color(0xFF6C5CE7);
const magicPink = Color(0xFFFD79A8);
const magicBlue = Color(0xFF74B9FF);
const magicGreen = Color(0xFF55EFC4);
const magicOrange = Color(0xFFFFA502);
const magicYellow = Color(0xFFFFD93D);
const worldBgAssets = [
  'assets/images/world_forest.png',
  'assets/images/world_sky.png',
  'assets/images/world_castle.png',
  'assets/images/world_workshop.png',
  'assets/images/world_time.png',
];
ThemeData theme() {
  final base = ThemeData(useMaterial3:true,fontFamily:'Vazirmatn',colorScheme:ColorScheme.fromSeed(seedColor:magicPurple).copyWith(onSurface:ink),scaffoldBackgroundColor:Colors.transparent);
  return base.copyWith(textTheme:base.textTheme.apply(bodyColor:ink,displayColor:ink).copyWith(bodyMedium:const TextStyle(fontSize:18,height:1.5),bodyLarge:const TextStyle(fontSize:20,height:1.5),titleLarge:const TextStyle(fontSize:24,fontWeight:FontWeight.w700,height:1.5)),appBarTheme:const AppBarTheme(backgroundColor:Colors.transparent,foregroundColor:ink,centerTitle:true,titleTextStyle:TextStyle(fontFamily:'Vazirmatn',color:ink,fontSize:24,fontWeight:FontWeight.bold)));
}
class Sky extends StatelessWidget {
  const Sky({super.key,required this.title,required this.child,this.world = -1});
  final String title;
  final Widget child;
  final int world;
  @override Widget build(BuildContext context) {
    final bg = world >= 0 && world < worldBgAssets.length ? worldBgAssets[world] : null;
    return DecoratedBox(
      decoration: BoxDecoration(
        image: bg != null ? DecorationImage(image: AssetImage(bg), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.35), BlendMode.darken)) : null,
        gradient: bg == null ? const LinearGradient(
          begin:Alignment.topCenter, end:Alignment.bottomCenter,
          colors:[Color(0xFFA29BFE), Color(0xFFDFE6FD), Color(0xFFFFEAA7), Color(0xFFFAB1A0)],
          stops:[0.0, 0.3, 0.7, 1.0],
        ) : null,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SafeArea(child: Center(child: ConstrainedBox(constraints:const BoxConstraints(maxWidth:630), child: child))),
      ),
    );
  }
}
class Pad extends StatelessWidget {
  const Pad({super.key,required this.children});
  final List<Widget> children;
  @override Widget build(BuildContext context)=> ListView(padding:const EdgeInsets.fromLTRB(18,8,18,24),children:[for(final w in children) Padding(padding:const EdgeInsets.only(bottom:12),child:w)]);
}
class PlayButton extends StatefulWidget {
  const PlayButton(this.label,this.action,{super.key,this.color=magicYellow});
  final String label;
  final VoidCallback? action;
  final Color color;
  @override State<PlayButton> createState()=>_PlayButtonState();
}
class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  late final AnimationController a=AnimationController(vsync:this,duration:const Duration(milliseconds:240));
  @override void dispose(){a.dispose();super.dispose();}
  @override Widget build(BuildContext context)=> AnimatedBuilder(
    animation:a,
    builder:(context,child)=>Transform.scale(scale:1-.05*Curves.easeOutBack.transform(a.value),child:child),
    child:Semantics(button:true,enabled:widget.action!=null,child:Listener(
      onPointerDown:(_){if(widget.action!=null)a.forward();},
      onPointerUp:(_)=>a.reverse(),
      onPointerCancel:(_)=>a.reverse(),
      child:Material(
        borderRadius:BorderRadius.circular(24),
        color:widget.action==null?const Color(0xFFEADFDB):widget.color,
        elevation:widget.action==null?0:6,
        shadowColor:widget.action==null?Colors.transparent:widget.color.withValues(alpha: 0.4),
        child:InkWell(
          borderRadius:BorderRadius.circular(24),
          onTap:widget.action,
          child:Padding(padding:const EdgeInsets.symmetric(vertical:14,horizontal:18),
            child:Center(child:Text(widget.label,textAlign:TextAlign.center,style:const TextStyle(color:ink,fontSize:18,height:1.5,fontWeight:FontWeight.bold)))),
        ),
      ),
    )),
  );
}
Future<T?> go<T>(BuildContext context,Widget page)=>Navigator.of(context).push<T>(PageRouteBuilder<T>(
  transitionDuration:const Duration(milliseconds:400),
  reverseTransitionDuration:const Duration(milliseconds:300),
  pageBuilder:(context,a,b)=>page,
  transitionsBuilder:(context,a,b,child){
    final curve=a.drive(CurveTween(curve:Curves.easeInOutCubic));
    return FadeTransition(opacity:curve,child:SlideTransition(position:curve.drive(Tween(begin:const Offset(-.08,.02),end:Offset.zero)),child:ScaleTransition(scale:curve.drive(Tween(begin:.95,end:1.0)),child:child)));
  },
));
