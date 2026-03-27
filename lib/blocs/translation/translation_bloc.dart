// blocs/translation/translation_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/translation_result.dart';
import '../../services/translation_pipeline.dart';
import '../../utils/audio_recorder.dart';
import '../../utils/audio_player.dart';
import '../../interfaces/i_audio_recorder.dart';

abstract class TranslationEvent extends Equatable { @override List<Object?> get props => []; }
class StartRecording extends TranslationEvent { final String src; StartRecording(this.src); @override List<Object?> get props => [src]; }
class StopRecording extends TranslationEvent {}
class CancelRecording extends TranslationEvent {}
class PlaySourceAudio extends TranslationEvent { final String text; PlaySourceAudio(this.text); @override List<Object?> get props => [text]; }
class PlayTranslatedAudio extends TranslationEvent { final String text; PlayTranslatedAudio(this.text); @override List<Object?> get props => [text]; }
class SwitchDirection extends TranslationEvent {}
class SelectLanguage extends TranslationEvent { final String src, tgt; SelectLanguage(this.src,this.tgt); @override List<Object?> get props => [src,tgt]; }
class ClearHistory extends TranslationEvent {}

abstract class TranslationState extends Equatable {
  final String sourceLang, targetLang;
  final bool autoPlay;
  final List<TranslationResult> history;
  const TranslationState({this.sourceLang='zh',this.targetLang='en',this.autoPlay=true,this.history=const[]});
  @override List<Object?> get props => [sourceLang,targetLang,autoPlay,history];
}
class TranslationIdle extends TranslationState { const TranslationIdle({super.sourceLang,super.targetLang,super.autoPlay,super.history}); }
class TranslationRecording extends TranslationState { final double volume; const TranslationRecording({required this.volume,super.sourceLang,super.targetLang,super.autoPlay,super.history}); @override List<Object?> get props => [volume,...super.props]; }
class TranslationProcessing extends TranslationState { final String phase; const TranslationProcessing({required this.phase,super.sourceLang,super.targetLang,super.autoPlay,super.history}); @override List<Object?> get props => [phase,...super.props]; }
class TranslationDone extends TranslationState { final TranslationResult result; const TranslationDone({required this.result,super.sourceLang,super.targetLang,super.autoPlay,super.history}); @override List<Object?> get props => [result,...super.props]; }
class TranslationError extends TranslationState { final String message; const TranslationError({required this.message,super.sourceLang,super.targetLang,super.autoPlay,super.history}); @override List<Object?> get props => [message,...super.props]; }

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final TranslationPipeline _pipeline;
  final AudioRecorderService _rec = AudioRecorderService();
  final AudioPlayerService _player = AudioPlayerService();

  TranslationBloc(this._pipeline) : super(const TranslationIdle()) {
    on<StartRecording>(_onStart);
    on<StopRecording>(_onStop);
    on<CancelRecording>((e,emit)=> emit(TranslationIdle(sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:state.history)));
    on<PlaySourceAudio>((e,emit) async { try{var a=await _pipeline.synthesizeOnly(e.text); await _player.playBytes(a); } catch(_){} });
    on<PlayTranslatedAudio>((e,emit) async { try{var a=await _pipeline.synthesizeOnly(e.text); await _player.playBytes(a); } catch(_){} });
    on<SwitchDirection>((e,emit) async { await _pipeline.switchDirection(); emit(TranslationIdle(sourceLang:_pipeline.sourceLang,targetLang:_pipeline.targetLang,autoPlay:state.autoPlay,history:state.history)); });
    on<SelectLanguage>((e,emit) { _pipeline.configure(sourceLang:e.src,targetLang:e.tgt); emit(TranslationIdle(sourceLang:e.src,targetLang:e.tgt,autoPlay:state.autoPlay,history:state.history)); });
    on<ClearHistory>((e,emit) => emit(TranslationIdle(sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay)));
  }

  Future<void> _onStart(StartRecording e, Emitter<TranslationState> emit) async {
    final ok = await _rec.startRecording();
    if(!ok){ emit(TranslationError(message:'麦克风权限被拒绝',sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:state.history)); return; }
    _rec.volumeStream.listen((v){});
    emit(TranslationRecording(volume:0.0,sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:state.history));
  }

  Future<void> _onStop(StopRecording e, Emitter<TranslationState> emit) async {
    emit(TranslationProcessing(phase:'recognizing',sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:state.history));
    final audio = await _rec.stopRecording();
    if(audio.isEmpty){ emit(TranslationIdle(sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:state.history)); return; }
    try{
      emit(TranslationProcessing(phase:'translating',sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:state.history));
      final r = await _pipeline.runFullPipeline(audioData:audio,autoPlay:state.autoPlay);
      if(!r.success){ emit(TranslationError(message:r.errorMessage??'翻译失败',sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:state.history)); return; }
      final result = TranslationResult(id:'${DateTime.now().millisecondsSinceEpoch}',sourceText:r.recognizedText,translatedText:r.translatedText,sourceLang:state.sourceLang,targetLang:state.targetLang,timestamp:DateTime.now(),asrDuration:r.asrDuration,mtDuration:r.mtDuration);
      emit(TranslationDone(result:result,sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:[...state.history,result]));
    } catch(ex){ emit(TranslationError(message:'$ex',sourceLang:state.sourceLang,targetLang:state.targetLang,autoPlay:state.autoPlay,history:state.history)); }
  }

  @override Future<void> close() async { await _rec.dispose(); await _player.dispose(); return super.close(); }
}
