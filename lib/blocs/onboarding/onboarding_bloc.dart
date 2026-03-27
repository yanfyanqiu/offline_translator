// blocs/onboarding/onboarding_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/model_loader.dart';
import '../../utils/downloader.dart';
import '../../interfaces/i_downloader.dart';
import '../../core/constants.dart';

// ---- Events ----
abstract class OnboardingEvent extends Equatable {
  @override List<Object?> get props => [];
}
class StartDiagnosis extends OnboardingEvent {}
class StartDownload extends OnboardingEvent {}
class DownloadProgressUpdated extends OnboardingEvent {
  final String model; final double progress; final int speed;
  DownloadProgressUpdated(this.model,this.progress,this.speed);
  @override List<Object?> get props => [model,progress,speed];
}
class DownloadCompleted extends OnboardingEvent { final String model; DownloadCompleted(this.model); @override List<Object?> get props => [model]; }
class DownloadFailed extends OnboardingEvent { final String model, error; DownloadFailed(this.model,this.error); @override List<Object?> get props => [model,error]; }
class StartLoadingModels extends OnboardingEvent {}
class ModelLoadingProgress extends OnboardingEvent { final String model; final double progress; ModelLoadingProgress(this.model,this.progress); @override List<Object?> get props => [model,progress]; }
class AllModelsLoaded extends OnboardingEvent {}
class LoadingFailed extends OnboardingEvent { final String error; LoadingFailed(this.error); @override List<Object?> get props => [error]; }

// ---- States ----
abstract class OnboardingState extends Equatable { @override List<Object?> get props => []; }
class OnboardingInitial extends OnboardingState {}
class DiagnosingModels extends OnboardingState {}
class ModelsDiagnosed extends OnboardingState { final bool asrExists,mtExists,ttsExists; ModelsDiagnosed({required this.asrExists,required this.mtExists,required this.ttsExists}); bool get needsDownload => !asrExists||!mtExists||!ttsExists; @override List<Object?> get props => [asrExists,mtExists,ttsExists]; }
class DownloadingModels extends OnboardingState {
  final String currentModel; final double progress; final int bytesPerSecond; final int downloadedCount; final int totalCount;
  DownloadingModels({required this.currentModel,required this.progress,required this.bytesPerSecond,required this.downloadedCount,required this.totalCount});
  @override List<Object?> get props => [currentModel,progress,bytesPerSecond,downloadedCount,totalCount];
}
class LoadingModels extends OnboardingState { final String currentModel; final double progress; LoadingModels({required this.currentModel,required this.progress}); @override List<Object?> get props => [currentModel,progress]; }
class AllReady extends OnboardingState {}
class OnboardingError extends OnboardingState { final String message; OnboardingError(this.message); @override List<Object?> get props => [message]; }

// ---- BLoC ----
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final ModelLoaderService _loader;
  final HTTPDownloader _dl = HTTPDownloader();

  OnboardingBloc(this._loader) : super(OnboardingInitial()) {
    on<StartDiagnosis>(_onDiagnose);
    on<StartDownload>(_onDownload);
    on<DownloadProgressUpdated>((e,emit)=> emit(DownloadingModels(currentModel:e.model,progress:e.progress,bytesPerSecond:e.speed,downloadedCount:0,totalCount:3)));
    on<DownloadCompleted>((e,emit){ add(StartLoadingModels()); });
    on<DownloadFailed>((e,emit)=> emit(OnboardingError('下载失败 [${e.model}]: ${e.error}')));
    on<StartLoadingModels>(_onLoadModels);
    on<ModelLoadingProgress>((e,emit)=> emit(LoadingModels(currentModel:e.model,progress:e.progress)));
    on<AllModelsLoaded>((e,emit)=> emit(AllReady()));
    on<LoadingFailed>((e,emit)=> emit(OnboardingError(e.error)));
  }

  Future<void> _onDiagnose(StartDiagnosis e, Emitter<OnboardingState> emit) async {
    emit(DiagnosingModels());
    final asr=await _loader.diagnose('asr');
    final mt=await _loader.diagnose('mt');
    final tts=await _loader.diagnose('tts');
    emit(ModelsDiagnosed(asrExists:asr.exists,mtExists:mt.exists,ttsExists:tts.exists));
  }

  Future<void> _onDownload(StartDownload e, Emitter<OnboardingState> emit) async {
    final asrPath=await _loader.getASRPath();
    final mtPath=await _loader.getMTPath();
    final ttsPath=await _loader.getTTSPath();
    final items=[
      DownloadItem(url:AppConstants.asrModelUrl,savePath:asrPath),
      DownloadItem(url:AppConstants.mtModelUrl,savePath:mtPath),
      DownloadItem(url:AppConstants.ttsModelUrl,savePath:ttsPath),
    ];
    await _dl.downloadBatch(items,
      onEachProgress:(url,p){ final m=url.contains('whisper')?'ASR':url.contains('HY-MT')?'MT':'TTS'; add(DownloadProgressUpdated(m,p,0)); },
      onEachComplete:(url){ add(DownloadCompleted(url.contains('whisper')?'ASR':url.contains('HY-MT')?'MT':'TTS')); },
      onEachError:(url,err){ add(DownloadFailed(url.contains('whisper')?'ASR':url.contains('HY-MT')?'MT':'TTS',err)); },
    );
  }

  Future<void> _onLoadModels(StartLoadingModels e, Emitter<OnboardingState> emit) async {
    try {
      final asr=await _loader.getASRPath(), mt=await _loader.getMTPath(), tts=await _loader.getTTSPath();
      await _loader.loadAll(asrPath:asr,mtPath:mt,ttsPath:tts,
        onEachProgress:(name,progress){ add(ModelLoadingProgress(name,progress)); },
        onError:(err){ add(LoadingFailed(err)); },
      );
      add(AllModelsLoaded());
    } catch(ex){ emit(OnboardingError('$ex')); }
  }
}
