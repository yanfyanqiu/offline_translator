// interfaces/i_tts_service.dart
class SpeakerInfo {
  final int id; final String name; final String language;
  const SpeakerInfo({required this.id, required this.name, required this.language});
}
abstract class ITTSService {
  Future<bool> initialize({required String modelPath, int speakerId = 0, int sampleRate = 24000});
  Future<List<int>> synthesize(String text, {int speakerId = 0});
  Future<void> synthesizeAndPlay(String text, {int speakerId = 0, double volume = 1.0, double speed = 1.0});
  Future<void> stop();
  Future<List<SpeakerInfo>> getAvailableSpeakers();
  Future<void> switchSpeaker(int speakerId);
  Future<void> setSpeed(double speed);
  Future<void> setVolume(double volume);
  Future<void> unload();
  Future<void> dispose();
  bool get isInitialized;
}
