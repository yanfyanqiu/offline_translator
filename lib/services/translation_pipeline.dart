// services/translation_pipeline.dart
import '../interfaces/i_asr_service.dart';
import '../interfaces/i_mt_service.dart';
import '../interfaces/i_tts_service.dart';

class PipelineResult {
  final String recognizedText, translatedText;
  final List<int>? audioData;
  final Duration asrDuration, mtDuration, ttsDuration;
  final bool success;
  final String? errorMessage;
  const PipelineResult({required this.recognizedText,required this.translatedText,this.audioData,this.asrDuration=Duration.zero,this.mtDuration=Duration.zero,this.ttsDuration=Duration.zero,this.success=true,this.errorMessage});
  factory PipelineResult.error(String msg) => PipelineResult(recognizedText:'',translatedText:'',success:false,errorMessage:msg);
}

class TranslationPipeline {
  IASRService? _asr;
  IMTService? _mt;
  ITTSService? _tts;
  String _src = 'zh', _tgt = 'en';

  void injectASR(IASRService s) => _asr = s;
  void injectMT(IMTService s)   => _mt  = s;
  void injectTTS(ITTSService s) => _tts = s;
  void configure({required String sourceLang, required String targetLang}) { _src = sourceLang; _tgt = targetLang; }

  Future<bool> initialize({required String asrPath, required String mtPath, required String ttsPath}) async {
    try {
      _asr ??= StubASR(); _mt ??= StubMT(); _tts ??= StubTTS();
      await _asr!.initialize(modelPath: asrPath, language: _src);
      await _mt!.initialize(modelPath: mtPath, sourceLang: _src, targetLang: _tgt);
      await _tts!.initialize(modelPath: ttsPath);
      return true;
    } catch(e) { return false; }
  }

  Future<PipelineResult> runFullPipeline({required List<int> audioData, bool autoPlay = true}) async {
    try {
      var sw = Stopwatch()..start();
      final recognized = await _asr!.recognize(audioData);
      sw.stop(); final asrDur = sw.elapsed;
      if (recognized.trim().isEmpty) return PipelineResult.error('未识别到语音');

      sw.reset()..start();
      final translated = await _mt!.translate(recognized);
      sw.stop(); final mtDur = sw.elapsed;

      List<int>? audio; Duration ttsDur = Duration.zero;
      if (autoPlay) {
        sw.reset()..start();
        audio = await _tts!.synthesize(translated);
        sw.stop(); ttsDur = sw.elapsed;
        await _tts!.synthesizeAndPlay(translated);
      }
      return PipelineResult(recognizedText: recognized, translatedText: translated, audioData: audio, asrDuration: asrDur, mtDuration: mtDur, ttsDuration: ttsDur);
    } catch(e) { return PipelineResult.error(e.toString()); }
  }

  Future<String> translateOnly(String text) => _mt!.translate(text);
  Future<String> recognizeOnly(List<int> d) => _asr!.recognize(d);
  Future<List<int>> synthesizeOnly(String text, {int speakerId=0}) => _tts!.synthesize(text, speakerId: speakerId);
  Future<void> switchDirection() async {
    final t = _src; _src = _tgt; _tgt = t;
    await _mt!.switchDirection(sourceLang: _src, targetLang: _tgt);
  }

  String get sourceLang => _src;
  String get targetLang => _tgt;
  bool get isInitialized => (_asr?.isInitialized ?? false) && (_mt?.isInitialized ?? false) && (_tts?.isInitialized ?? false);
  Future<void> dispose() async { await _asr?.dispose(); await _mt?.dispose(); await _tts?.dispose(); }
}

// ===== STUB IMPLEMENTATIONS (replace with real llama.cpp bindings) =====

class StubASR implements IASRService {
  bool _init = false;
  @override Future<bool> initialize({required String modelPath, String language='zh'}) async { await Future.delayed(Duration(milliseconds:500)); _init=true; return true; }
  @override Future<String> recognize(List<int> audioData) async { await Future.delayed(Duration(milliseconds:300)); return '【ASR STUB】语音识别结果（请替换为 whisper binding）'; }
  @override Stream<String> recognizeStream({required void Function(String) onResult, required void Function(Exception) onError}) => const Stream.empty();
  @override Future<void> stopStream() async {}
  @override Future<void> dispose() async {}
  @override bool get isInitialized => _init;
  @override int? get lastInferenceMs => null;
}

class StubMT implements IMTService {
  bool _init = false;
  @override Future<bool> initialize({required String modelPath, required String sourceLang, required String targetLang}) async { await Future.delayed(Duration(milliseconds:800)); _init=true; return true; }
  @override Future<String> translate(String text) async { await Future.delayed(Duration(milliseconds:500)); if (text.contains('你好')) return 'Hello'; if (text.contains('Hello')) return '你好'; return '【译文 STUB】$text'; }
  @override Future<List<String>> translateBatch(List<String> texts) async => [for(var t in texts) await translate(t)];
  @override Future<void> switchDirection({required String sourceLang, required String targetLang}) async {}
  @override Future<List<String>> getSupportedLanguages() async => ['zh','en','ja','ko','fr','de'];
  @override Future<void> unload() async {}
  @override Future<void> dispose() async {}
  @override bool get isInitialized => _init;
  @override int? get lastInferenceMs => null;
}

class StubTTS implements ITTSService {
  bool _init = false;
  @override Future<bool> initialize({required String modelPath, int speakerId=0, int sampleRate=24000}) async { await Future.delayed(Duration(milliseconds:400)); _init=true; return true; }
  @override Future<List<int>> synthesize(String text, {int speakerId=0}) async { await Future.delayed(Duration(milliseconds:200)); return List.filled(4800, 0); }
  @override Future<void> synthesizeAndPlay(String text, {int speakerId=0, double volume=1.0, double speed=1.0}) async { await synthesize(text, speakerId: speakerId); }
  @override Future<void> stop() async {}
  @override Future<List<SpeakerInfo>> getAvailableSpeakers() async => [SpeakerInfo(id:0,name:'女声',language:'zh'), SpeakerInfo(id:1,name:'男声',language:'zh')];
  @override Future<void> switchSpeaker(int speakerId) async {}
  @override Future<void> setSpeed(double speed) async {}
  @override Future<void> setVolume(double volume) async {}
  @override Future<void> unload() async {}
  @override Future<void> dispose() async {}
  @override bool get isInitialized => _init;
}
