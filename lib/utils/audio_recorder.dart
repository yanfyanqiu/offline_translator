// utils/audio_recorder.dart
import 'package:record/record.dart';
import '../interfaces/i_audio_recorder.dart';

class AudioRecorderService implements IAudioRecorder {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Amplitude>? _volSub;
  final StreamController<double> _volCtrl = StreamController<double>.broadcast();
  double _vol = 0.0;
  bool _recording = false;

  @override Future<bool> startRecording({int sampleRate=16000, int channels=1, AudioEncoding encoding=AudioEncoding.pcm16bit}) async {
    if (!await _recorder.hasPermission()) return false;
    _recording = true;
    final config = RecordConfig(encoder: _map(encoding), sampleRate: sampleRate, numChannels: channels);
    await _recorder.start(config, path: '');
    _volSub = _recorder.onAmplitudeChanged(Duration(milliseconds:100)).listen((amp) {
      _vol = ((amp.current+60)/60).clamp(0.0,1.0);
      _volCtrl.add(_vol);
    });
    return true;
  }

  @override Future<List<int>> stopRecording() async {
    await _volSub?.cancel();
    _recording = false;
    await _recorder.stop();
    return [];
  }

  @override double get currentVolume => _vol;
  @override Stream<double> get volumeStream => _volCtrl.stream;
  @override bool get isRecording => _recording;
  @override Future<void> dispose() async { await _volSub?.cancel(); await _volCtrl.close(); await _recorder.dispose(); }

  AudioEncoder _map(AudioEncoding e) {
    switch(e) {
      case AudioEncoding.pcm16bit: return AudioEncoder.pcm16bits;
      case AudioEncoding.aac:     return AudioEncoder.aacLc;
      case AudioEncoding.opus:     return AudioEncoder.opus;
    }
  }
  @override Future<List<int>> getRecordedData() async => [];
}
