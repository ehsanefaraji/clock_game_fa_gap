class PlayerProgress {
  PlayerProgress(this.stars, this.owned, this.spent, this.coins, this.limit, this.music, this.voice, this.effects, this.wearing, this.daily);
  PlayerProgress.empty():this({}, {}, 0, 0, 0, true, true, true, '', '');
  final Map<String,int> stars;
  final Set<String> owned;
  int spent, coins, limit;
  bool music, voice, effects;
  String wearing, daily;
  int get balance => coins - spent;
  int get total => stars.values.fold(0,(a,b)=>a+b);
  bool open(int w,int l) => w == 0 && l == 0 || (l == 0 ? stars['${w-1}:9'] : stars['$w:${l-1}']) == 3;
  Map<String,dynamic> toJson()=> {'stars':stars,'owned':owned.toList(),'spent':spent,'coins':coins,'limit':limit,'music':music,'voice':voice,'effects':effects,'wearing':wearing,'daily':daily};
  factory PlayerProgress.fromJson(Map<String,dynamic> j)=> PlayerProgress(Map<String,int>.from(j['stars'] as Map), Set<String>.from(j['owned'] as List),j['spent'] as int,j['coins'] as int,j['limit'] as int,j['music'] as bool,j['voice'] as bool,j['effects'] as bool,j['wearing'] as String,j['daily'] as String);
}
