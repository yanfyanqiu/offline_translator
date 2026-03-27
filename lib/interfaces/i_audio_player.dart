// interfaces/i_audio_player.dart
enum PlaybackChannel { speaker, headset, bluetoothA, bluetoothB }
abstract class IAudioPlayer {
  Future<void> playBytes(List<int> audioData, {int sampleRate = 24000, double volume = 1.0, double speed = 1.0});
  Future<void> playFile(String filePath);
  Future<void> playUrl(String url);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> setVolume(double volume);
  Future<void> setSpeed(double speed);
  Future<void> setOutputChannel(PlaybackChannel channel);
  Stream<void> get onComplete;
  Stream<Exception> get onError;
  bool get isPlaying;
  Future<void> dispose();
}
