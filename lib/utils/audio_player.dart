// utils/audio_player.dart
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import '../interfaces/i_audio_player.dart';

class AudioPlayerService implements IAudioPlayer {
  final AudioPlayer _p = AudioPlayer();
  double _vol = 1.0, _speed = 1.0;
  final _onCompleteCtrl = StreamController<void>.broadcast();
  final _onErrorCtrl = StreamController<Exception>.broadcast();

  AudioPlayerService() {
    _p.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) _onCompleteCtrl.add(null);
    });
  }

  @override Stream<void> get onComplete => _onCompleteCtrl.stream;
  @override Stream<Exception> get onError => _onErrorCtrl.stream;
  @override bool get isPlaying => _p.playing;

  @override Future<void> playBytes(List<int> data, {int sampleRate=24000, double volume=1.0, double speed=1.0}) async {
    final tmp = '${Directory.systemTemp.path}/tts_temp.pcm';
    await File(tmp).writeAsBytes(data);
    await _p.setFilePath(tmp);
    await _p.setSpeed(speed); await _p.setVolume(volume);
    await _p.seek(Duration.zero); await _p.play();
  }

  @override Future<void> playFile(String path) async { await _p.setFilePath(path); await _p.play(); }
  @override Future<void> playUrl(String url) async { await _p.setUrl(url); await _p.play(); }
  @override Future<void> pause()  async { await _p.pause(); }
  @override Future<void> resume() async { await _p.play(); }
  @override Future<void> stop()   async { await _p.stop(); }
  @override Future<void> setVolume(double v) async { _vol = v.clamp(0.0,1.0); await _p.setVolume(_vol); }
  @override Future<void> setSpeed(double s) async { _speed = s.clamp(0.5,2.0); await _p.setSpeed(_speed); }
  @override Future<void> setOutputChannel(PlaybackChannel channel) async {}
  @override Future<void> dispose() async { await _onCompleteCtrl.close(); await _onErrorCtrl.close(); await _p.dispose(); }
}
