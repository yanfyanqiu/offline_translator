// ui/screens/model_loading_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/onboarding/onboarding_bloc.dart';
import '../../core/theme.dart';
import '../../core/locale.dart';
import 'home_screen.dart';

class ModelLoadingScreen extends StatefulWidget {
  const ModelLoadingScreen({super.key});
  @override State<ModelLoadingScreen> createState() => _ModelLoadingScreenState();
}
class _ModelLoadingScreenState extends State<ModelLoadingScreen> {
  String _current = 'ASR';
  double _progress = 0.0;
  String get _lang => 'zh';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingBloc>().add(StartLoadingModels());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (ctx, state) {
          if (state is LoadingModels) { setState(() { _current = state.currentModel; _progress = state.progress; }); }
          else if (state is AllReady) { Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen())); }
          else if (state is OnboardingError) { ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(state.message))); }
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:100,height:100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors:[AppTheme.primaryBlue,AppTheme.primaryPink]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.translate,size:56,color:Colors.white),
                  ),
                  const SizedBox(height:40),
                  const Text('正在加载模型',style:TextStyle(color:AppTheme.textWhite,fontSize:22,fontWeight:FontWeight.w600)),
                  const SizedBox(height:8),
                  const Text('首次加载可能需要几分钟',style:TextStyle(color:AppTheme.textGray,fontSize:14)),
                  const SizedBox(height:48),
                  _buildItem('🎙','语音识别模型','whisper-small'),
                  const SizedBox(height:16),
                  _buildItem('🔄','翻译模型','HY-MT1.5-1.8B'),
                  const SizedBox(height:16),
                  _buildItem('🔊','语音合成模型','neutts-air'),
                  const SizedBox(height:48),
                  Text(_statusText(),style:const TextStyle(color:AppTheme.textGray,fontSize:13)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  double _getP(String m) {
    final order=['ASR','MT','TTS'];
    final ci=order.indexOf(_current), mi=order.indexOf(m);
    if (mi<ci) return 1.0;
    if (mi>ci) return 0.0;
    return _progress;
  }
  String _statusText() {
    switch(_current){case 'ASR':return AppLocale.t(_lang,'loading_asr');case 'MT':return AppLocale.t(_lang,'loading_mt');case 'TTS':return AppLocale.t(_lang,'loading_tts');default:return AppLocale.t(_lang,'loading_done');}
  }
  Widget _buildItem(String emoji, String name, String sub) {
    final isDone = _getP(order.indexOf(name.split(' ')[0])==-1?'ASR':name) >=1.0;
    final isCurrent = _current==name;
    final color = isDone?AppTheme.successGreen:(isCurrent?AppTheme.primaryBlue:AppTheme.textGray);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:20,vertical:14),
      decoration: BoxDecoration(
        color:AppTheme.cardDark,
        borderRadius:BorderRadius.circular(16),
        border:isCurrent?Border.all(color:AppTheme.primaryBlue.withOpacity(0.5),width:1.5):null,
      ),
      child: Row(children:[
        Text(emoji,style:const TextStyle(fontSize:24)),
        const SizedBox(width:14),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(name,style:TextStyle(color:color,fontWeight:FontWeight.w600)),
          Text(sub,style:const TextStyle(color:AppTheme.textGray,fontSize:11)),
          if(isCurrent)...[const SizedBox(height:8),ClipRRect(borderRadius:BorderRadius.circular(4),child:LinearProgressIndicator(value:_progress,minHeight:4))],
        ])),
        if(isDone) const Icon(Icons.check_circle,color:AppTheme.successGreen,size:22)
        else if(isCurrent) SizedBox(width:22,height:22,child:CircularProgressIndicator(value:_progress,strokeWidth:2,color:AppTheme.primaryBlue))
        else const Icon(Icons.circle_outlined,color:AppTheme.textGray,size:22),
      ]),
    );
  }
  static const order=['ASR','MT','TTS'];
}
