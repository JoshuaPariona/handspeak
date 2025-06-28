import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speech(String s) async {
    await _flutterTts.speak(s);
  }
}
