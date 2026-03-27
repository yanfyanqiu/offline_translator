// interfaces/i_asr_service.dart
abstract class IASRService {
  Future<bool> initialize({required String modelPath, String language = 'zh'});
  Future<String> recognize(List<int> audioData);
  Stream<String> recognizeStream({required void Function(String) onResult, required void Function(Exception) onError});
  Future<void> stopStream();
  Future<void> dispose();
  bool get isInitialized;
  int? get lastInferenceMs;
}
