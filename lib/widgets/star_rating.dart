import 'package:flutter/material.dart';
import '../models/question.dart';
class StarRating extends StatelessWidget {
  const StarRating(this.count,{super.key});
  final int count;
  @override Widget build(BuildContext context)=>Semantics(label:'${fa(count)} از ۳ ستاره',child:ExcludeSemantics(child:Text(List.generate(3,(i)=>i<count?'★':'☆').join(' '),textAlign:TextAlign.center,style:const TextStyle(color:Color(0xFF915014),fontSize:34))));
}
