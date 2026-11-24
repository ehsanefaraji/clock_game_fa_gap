import 'package:flutter/material.dart';
const ink = Color(0xFF3D2C1E);
const paper = Color(0xFFFFFAEE);
ThemeData theme() {
  final base = ThemeData(useMaterial3:true,fontFamily:'Vazirmatn',colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFFFF8C42)).copyWith(onSurface:ink),scaffoldBackgroundColor:Colors.transparent);
  return base.copyWith(textTheme:base.textTheme.apply(bodyColor:ink,displayColor:ink).copyWith(bodyMedium:const TextStyle(fontSize:18,height:1.5),bodyLarge:const TextStyle(fontSize:20,height:1.5),titleLarge:const TextStyle(fontSize:24,fontWeight:FontWeight.w700,height:1.5)),appBarTheme:const AppBarTheme(backgroundColor:Colors.transparent,foregroundColor:ink,centerTitle:true,titleTextStyle:TextStyle(fontFamily:'Vazirmatn',color:ink,fontSize:24,fontWeight:FontWeight.bold)));
}
class Sky extends StatelessWidget {
  const Sky({super.key,required this.title,required this.child});
  final String title;
  final Widget child;
  @override Widget build(BuildContext context) => DecoratedBox(decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xFFCEF1FF),Color(0xFFFFE1E9)])),child:Scaffold(appBar:AppBar(title:Text(title)),body:SafeArea(child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:630),child:child)))));
}
class Pad extends StatelessWidget {
  const Pad({super.key,required this.children});
  final List<Widget> children;
  @override Widget build(BuildContext context)=> ListView(padding:const EdgeInsets.fromLTRB(18,8,18,24),children:[for(final w in children) Padding(padding:const EdgeInsets.only(bottom:12),child:w)]);
}
class PlayButton extends StatefulWidget {
  const PlayButton(this.label,this.action,{super.key,this.color=const Color(0xFFFFD166)});
  final String label;
  final VoidCallback? action;
  final Color color;
  @override State<PlayButton> createState()=>_PlayButtonState();
}
class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  late final AnimationController a=AnimationController(vsync:this,duration:const Duration(milliseconds:240));
  @override void dispose(){a.dispose();super.dispose();}
  @override Widget build(BuildContext context)=> AnimatedBuilder(animation:a,builder:(context,child)=>Transform.scale(scale:1-.05*Curves.easeOutBack.transform(a.value),child:child),child:Semantics(button:true,enabled:widget.action!=null,child:Listener(onPointerDown:(_){if(widget.action!=null)a.forward();},onPointerUp:(_)=>a.reverse(),onPointerCancel:(_)=>a.reverse(),child:Material(borderRadius:BorderRadius.circular(24),color:widget.action==null?const Color(0xFFEADFDB):widget.color,elevation:widget.action==null?0:3,shadowColor:const Color(0x40774664),child:InkWell(borderRadius:BorderRadius.circular(24),onTap:widget.action,child:Padding(padding:const EdgeInsets.symmetric(vertical:12,horizontal:16),child:Center(child:Text(widget.label,textAlign:TextAlign.center,style:const TextStyle(color:ink,fontSize:18,height:1.5,fontWeight:FontWeight.bold)))))))));
}
Future<T?> go<T>(BuildContext context,Widget page)=>Navigator.of(context).push<T>(PageRouteBuilder<T>(transitionDuration:const Duration(milliseconds:300),reverseTransitionDuration:const Duration(milliseconds:260),pageBuilder:(context,a,b)=>page,transitionsBuilder:(context,a,b,child){final curve=a.drive(CurveTween(curve:Curves.easeInOut));return FadeTransition(opacity:curve,child:SlideTransition(position:curve.drive(Tween(begin:const Offset(-.06,0),end:Offset.zero)),child:child));}));
