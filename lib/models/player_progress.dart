class PlayerProgress {
  PlayerProgress(this.stars, this.owned, this.spent, this.coins, this.limit, this.music, this.voice, this.effects, this.wearing, this.daily);
  PlayerProgress.empty():this({}, {}, 0, 0, 0, true, true, true, '', '');
  final Map<String,int> stars;
  final Set<String> owned;
  int spent, coins, limit;
  bool music, voice, effects;
  String wearing, daily;
  int lastWorld = 0;
  bool completedWorld(int world) => List.generate(10, (i) => stars['$world:$i'] ?? 0).every((count) => count > 0);
  int get nextStoryLevel {
    for (final minimum in [1, 3]) {
      for (var i = 0; i < 10; i++) {
        if ((stars['$lastWorld:$i'] ?? 0) < minimum) return i;
      }
    }
    return 9;
  }
  int get balance => coins - spent;
  int get total => stars.values.fold(0,(a,b)=>a+b);
  // همهٔ مراحل همیشه باز هستند — قفل برداشته شد
  bool open(int w,int l) => true;
  Map<String,dynamic> toJson()=> {'stars':stars,'owned':owned.toList(),'spent':spent,'coins':coins,'limit':limit,'music':music,'voice':voice,'effects':effects,'wearing':wearing,'daily':daily,'lastWorld':lastWorld};
  factory PlayerProgress.fromJson(Map<String,dynamic> j)=> PlayerProgress(Map<String,int>.from(j['stars'] as Map), Set<String>.from(j['owned'] as List),j['spent'] as int,j['coins'] as int,j['limit'] as int,j['music'] as bool,j['voice'] as bool,j['effects'] as bool,j['wearing'] as String,j['daily'] as String)..lastWorld = (j['lastWorld'] as int? ?? 0).clamp(0, 4).toInt();
}
