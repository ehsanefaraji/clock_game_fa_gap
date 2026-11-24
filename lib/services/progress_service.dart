import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_progress.dart';
class ProgressService {
  ProgressService(this.prefs);
  final SharedPreferences prefs;
  static String day() => DateTime.now().toLocal().toIso8601String().split('T').first;
  int get seconds => prefs.getInt('usage_${day()}') ?? 0;
  Future<bool> tick() => prefs.setInt('usage_${day()}',seconds+1);
  PlayerProgress load() {
    try { return PlayerProgress.fromJson(jsonDecode(prefs.getString('player') ?? '{}') as Map<String,dynamic>); }
    catch (_) { return PlayerProgress.empty(); }
  }
  Future<bool> save(PlayerProgress p) => prefs.setString('player',jsonEncode(p.toJson()));
}
