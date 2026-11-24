import 'package:flutter_tts/flutter_tts.dart';
class TtsService {
  final _tts = FlutterTts();
  Future<bool>? _ready;
  Future<bool> _init() async {
    try {
      if (await _tts.isLanguageAvailable('fa-IR') != true) return false;
      await _tts.setLanguage('fa-IR');
      await _tts.setSpeechRate(.40);
      return true;
    } catch (_) { return false; }
  }
  Future<bool> say(String text) async {
    try {
      if (!await (_ready ??= _init())) return false;
      await _tts.stop(); await _tts.speak(text); return true;
    } catch (_) {return false;}
  }
  Future<void> stop() async { try { await _tts.stop(); } catch (_) {} }
}
