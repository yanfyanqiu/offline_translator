// interfaces/i_model_loader.dart
enum ModelLoadStatus { notLoaded, downloading, loadingASR, loadingMT, loadingTTS, allLoaded, error }

class ModelDiagnostics {
  final String modelName;
  final bool exists;
  final bool isValid;
  final int? fileSizeBytes;
  const ModelDiagnostics({required this.modelName, required this.exists, this.isValid = false, this.fileSizeBytes});
}

abstract class IModelLoader {
  Future<bool> loadASR({required String modelPath, void Function(double)? onProgress, void Function(String)? onError});
  Future<bool> loadMT({required String modelPath, void Function(double)? onProgress, void Function(String)? onError});
  Future<bool> loadTTS({required String modelPath, void Function(double)? onProgress, void Function(String)? onError});
  Future<void> loadAll({required String asrPath, required String mtPath, required String ttsPath, void Function(String, double)? onEachProgress, void Function(String)? onError});
  Future<void> unloadASR();
  Future<void> unloadMT();
  Future<void> unloadTTS();
  ModelLoadStatus get status;
  Future<ModelDiagnostics> diagnose(String modelName);
}
