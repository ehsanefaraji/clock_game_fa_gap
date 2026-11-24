import 'package:audioplayers/audioplayers.dart';
class AudioService {
  final _music = AudioPlayer();
  final _effects = AudioPlayer();
  bool _playing = false;
  Future<void> music(bool on) async {
    if (_playing == on) return;
    _playing = on;
    try {
      if (on) { await _music.setReleaseMode(ReleaseMode.loop); await _music.play(AssetSource('audio/music.mp3'),volume:.16); }
      else { await _music.stop(); }
    } catch (_) { _playing = false; }
  }
  Future<void> play(String name) async { try { await _effects.stop(); await _effects.play(AssetSource('audio/$name.mp3'),volume:.48); } catch (_) {} }
}
