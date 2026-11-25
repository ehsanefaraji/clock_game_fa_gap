import 'dart:math';
import 'package:clock_game_fa/models/player_progress.dart';
import 'package:clock_game_fa/models/question.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  test('Persian digits and time idioms', () {
    expect(fa('0123456789'),'۰۱۲۳۴۵۶۷۸۹');
    expect(digital(5),'۱۲:۰۵');
    expect([180,195,210,225,235].map(words),['ساعت سه','سه و ربع','سه و نیم','سه و چهل و پنج دقیقه','پنج دقیقه به چهار']);
    expect(words(715),'پنج دقیقه به دوازده');
    expect(wrapTime(-5),715);
  });
  test('all story levels generate five distinct clocks and valid choices', () {
    for(var w=0;w<5;w++){
      for(var l=0;l<10;l++){
        final qs=Question.make(w,l,5,Random(w*10+l));
        expect(qs.map((q)=>q.answer).toSet(),hasLength(5));
        for(final q in qs){expect(q.options.toSet(),hasLength(4));expect(q.options,contains(q.answer));expect(q.answer,inInclusiveRange(0,719));if(q.task==Task.math)expect(q.answer,wrapTime(q.start+q.delta));}
      }
    }
  });
  test('taskFilter generates only specified task type', () {
    final readQs=Question.make(0,0,5,Random(42),taskFilter:Task.read);
    for(final q in readQs) expect(q.task,Task.read);
    final setQs=Question.make(0,0,5,Random(42),taskFilter:Task.set);
    for(final q in setQs) expect(q.task,Task.set);
    final mathQs=Question.make(4,5,5,Random(42),taskFilter:Task.math);
    for(final q in mathQs) expect(q.task,Task.math);
  });
  test('distractors have varied hours and minutes', () {
    for(var w=0;w<5;w++){
      for(var l=0;l<5;l++){
        final qs=Question.make(w,l,5,Random(w*100+l));
        for(final q in qs){
          final hours=q.options.map((t)=>t~/60).toSet();
          final mins=q.options.map((t)=>t%60).toSet();
          // حداقل ۲ ساعت متفاوت و ۲ دقیقهٔ متفاوت در گزینه‌ها
          expect(hours.length,greaterThanOrEqualTo(2));
          expect(mins.length,greaterThanOrEqualTo(2));
        }
      }
    }
  });
  test('all levels unlocked and profile fields persist', () {
    final p=PlayerProgress.empty();
    expect(p.open(0,0),isTrue);
    expect(p.open(0,1),isTrue);
    expect(p.open(1,0),isTrue);
    expect(p.open(4,9),isTrue);
    p.stars['0:0']=3;p.stars['0:9']=3;p.coins=70;p.owned.add('hat');p.spent=60;
    final copy=PlayerProgress.fromJson(p.toJson());
    expect(copy.open(0,1),isTrue);
    expect(copy.open(1,0),isTrue);
    expect(copy.balance,10);
    expect(copy.owned,contains('hat'));
  });
}
