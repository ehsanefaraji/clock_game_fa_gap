import 'dart:math';

String fa(Object value) => '$value'.replaceAllMapped(RegExp('[0-9]'), (m) => '۰۱۲۳۴۵۶۷۸۹'[int.parse(m[0]!)]);
// FIX: اعداد منفی را هم درست مدیریت کن — ((t % 720) + 720) % 720 همیشه ۰-۷۱۹ برمی‌گرداند
int wrapTime(int t) => ((t % 720) + 720) % 720;
const hourWords = ['دوازده','یک','دو','سه','چهار','پنج','شش','هفت','هشت','نه','ده','یازده'];
const minuteWords = ['صفر','پنج','ده','پانزده','بیست','بیست و پنج','سی','سی و پنج','چهل','چهل و پنج','پنجاه','پنجاه و پنج'];
String words(int t) {
  final w = wrapTime(t);
  final h = (w ~/ 60) % 12;
  final m = w % 60;
  final hour = hourWords[h];
  return switch (m) {
    0 => 'ساعت $hour',
    15 => '$hour و ربع',
    30 => '$hour و نیم',
    45 => 'یک ربع به ${hourWords[(h + 1) % 12]}',
    55 => 'پنج دقیقه به ${hourWords[(h + 1) % 12]}',
    _ => '$hour و ${m % 5 == 0 ? minuteWords[m ~/ 5] : fa(m)} دقیقه',
  };
}
String digital(int t) { final w = wrapTime(t); return fa('${(w ~/ 60) % 12 == 0 ? 12 : (w ~/ 60) % 12}:${(w % 60).toString().padLeft(2,'0')}'); }
enum Task { read, set, math }
class Question {
  const Question(this.answer, this.task, this.options, {this.start = 0, this.delta = 0});
  final int answer, start, delta;
  final Task task;
  final List<int> options;
  static List<Question> make(int world, int level, int count, Random random, {Task? taskFilter}) {
    final offsets = <List<int>>[[0],[30],[15,45],[5,10,20,25,35,40,50,55],List.generate(12,(i)=>i*5)][world];
    final used = <int>{};
    return List.generate(count, (i) {
      final task = taskFilter ?? (world == 4 && (i % 2 == 1 || level > 5 && i % 3 == 0) ? Task.math : (level > 1 && (i + level) % 3 == 0 ? Task.set : Task.read));
      int start, answer, delta;
      do {
        start = random.nextInt(12)*60 + offsets[random.nextInt(offsets.length)];
        delta = task == Task.math ? [5,10,15,30,60,75][random.nextInt(level < 4 ? 4 : 6)] : 0;
        answer = wrapTime(start + delta);
      } while (!used.add(answer));
      // گزینه‌های متنوع: ساعت و دقیقهٔ متفاوت
      final candidates = <int>{answer};
      candidates.add(wrapTime(answer + 5));
      candidates.add(wrapTime(answer - 5));
      while (candidates.length < 4) {
        final dh = 1 + random.nextInt(11);
        final dm = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55][random.nextInt(11)];
        candidates.add(wrapTime(answer + dh * 60 + dm));
      }
      // همه گزینه‌ها را با wrapTime نرمال‌سازی کن
      return Question(answer, task, candidates.map(wrapTime).toList()..shuffle(random),start:start,delta:delta);
    });
  }
}
