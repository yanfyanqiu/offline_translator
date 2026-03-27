// blocs/settings/settings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable { @override List<Object?> get props => []; }
class UpdateSpeed extends SettingsEvent { final double v; UpdateSpeed(this.v); @override List<Object?> get props => [v]; }
class UpdateVolume extends SettingsEvent { final double v; UpdateVolume(this.v); @override List<Object?> get props => [v]; }
class UpdateVoice extends SettingsEvent { final int id; final String name; UpdateVoice(this.id,this.name); @override List<Object?> get props => [id,name]; }
class UpdateAutoPlay extends SettingsEvent { final bool v; UpdateAutoPlay(this.v); @override List<Object?> get props => [v]; }

class SettingsState extends Equatable {
  final double speed, volume;
  final int voiceId;
  final String voiceName;
  final bool autoPlay;
  const SettingsState({this.speed=1.0,this.volume=1.0,this.voiceId=0,this.voiceName='女声',this.autoPlay=true});
  SettingsState copyWith({double? speed,double? volume,int? voiceId,String? voiceName,bool? autoPlay}) =>
    SettingsState(speed:speed??this.speed,volume:volume??this.volume,voiceId:voiceId??this.voiceId,voiceName:voiceName??this.voiceName,autoPlay:autoPlay??this.autoPlay);
  @override List<Object?> get props => [speed,volume,voiceId,voiceName,autoPlay];
}

class SettingsBloc extends Bloc<SettingsEvent,SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<UpdateSpeed>((e,emit)=>emit(state.copyWith(speed:e.v)));
    on<UpdateVolume>((e,emit)=>emit(state.copyWith(volume:e.v)));
    on<UpdateVoice>((e,emit)=>emit(state.copyWith(voiceId:e.id,voiceName:e.name)));
    on<UpdateAutoPlay>((e,emit)=>emit(state.copyWith(autoPlay:e.v)));
  }
}
