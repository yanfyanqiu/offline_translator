// interfaces/i_mt_service.dart
abstract class IMTService {
  Future<bool> initialize({required String modelPath, required String sourceLang, required String targetLang});
  Future<String> translate(String text);
  Future<List<String>> translateBatch(List<String> texts);
  Future<void> switchDirection({required String sourceLang, required String targetLang});
  Future<List<String>> getSupportedLanguages();
  Future<void> unload();
  Future<void> dispose();
  bool get isInitialized;
  int? get lastInferenceMs;
}
