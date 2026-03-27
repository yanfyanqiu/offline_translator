// services/model_loader.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../interfaces/i_model_loader.dart';
import 'translation_pipeline.dart';

class DefaultModels {
  static const asrFile = 'whisper-small.gguf';
  static const mtFile  = 'HY-MT1.5-1.8B-q5_k_m.gguf';
  static const ttsFile = 'neutts-air-Q4_0.gguf';
}

class ModelLoaderService implements IModelLoader {
  final TranslationPipeline _pipeline;
  ModelLoadStatus _status = ModelLoadStatus.notLoaded;
  ModelLoaderService(this._pipeline);

  Future<String> _getModelsDir() async {
    final dir = Directory('${(await getApplicationDocumentsDirectory()).path}/models');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  Future<String> getASRPath() async => '${await _getModelsDir()}/${DefaultModels.asrFile}';
  Future<String> getMTPath()  async => '${await _getModelsDir()}/${DefaultModels.mtFile}';
  Future<String> getTTSPath() async => '${await _getModelsDir()}/${DefaultModels.ttsFile}';

  @override Future<ModelDiagnostics> diagnose(String modelName) async {
    final path = await (modelName=='asr'?getASRPath():modelName=='mt'?getMTPath():getTTSPath());
    final file = File(path);
    final exists = await file.exists();
    int? size; bool valid = false;
    if (exists) { size = await file.length(); valid = size > 1024*1024; }
    return ModelDiagnostics(modelName: modelName, exists: exists, isValid: valid, fileSizeBytes: size);
  }

  @override Future<bool> loadASR({required String modelPath, void Function(double)? onProgress, void Function(String)? onError}) async {
    _status = ModelLoadStatus.loadingASR;
    try { onProgress?.call(0.1); _pipeline.injectASR(StubASR()); onProgress?.call(1.0); return true; }
    catch(e) { onError?.call(e.toString()); _status = ModelLoadStatus.error; return false; }
  }
  @override Future<bool> loadMT({required String modelPath, void Function(double)? onProgress, void Function(String)? onError}) async {
    _status = ModelLoadStatus.loadingMT;
    try { onProgress?.call(0.1); _pipeline.injectMT(StubMT()); onProgress?.call(1.0); return true; }
    catch(e) { onError?.call(e.toString()); _status = ModelLoadStatus.error; return false; }
  }
  @override Future<bool> loadTTS({required String modelPath, void Function(double)? onProgress, void Function(String)? onError}) async {
    _status = ModelLoadStatus.loadingTTS;
    try { onProgress?.call(0.1); _pipeline.injectTTS(StubTTS()); onProgress?.call(1.0); return true; }
    catch(e) { onError?.call(e.toString()); _status = ModelLoadStatus.error; return false; }
  }
  @override Future<void> loadAll({required String asrPath, required String mtPath, required String ttsPath, void Function(String,double)? onEachProgress, void Function(String)? onError}) async {
    await loadASR(modelPath:asrPath, onProgress:(p)=>onEachProgress?.call('ASR',p), onError:onError);
    await loadMT(modelPath:mtPath,  onProgress:(p)=>onEachProgress?.call('MT',p),  onError:onError);
    await loadTTS(modelPath:ttsPath,onProgress:(p)=>onEachProgress?.call('TTS',p),onError:onError);
    _status = ModelLoadStatus.allLoaded;
  }
  @override Future<void> unloadASR() async {}
  @override Future<void> unloadMT()  async {}
  @override Future<void> unloadTTS() async {}
  @override ModelLoadStatus get status => _status;
}
