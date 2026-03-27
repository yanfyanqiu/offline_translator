// interfaces/i_audio_recorder.dart
enum AudioEncoding { pcm16bit, aac, opus }
abstract class IAudioRecorder {
  Future<bool> startRecording({int sampleRate = 16000, int channels = 1, AudioEncoding encoding = AudioEncoding.pcm16bit});
  Future<List<int>> getRecordedData();
  Future<List<int>> stopRecording();
  double get currentVolume;
  Stream<double> get volumeStream;
  bool get isRecording;
  Future<void> dispose();
}
