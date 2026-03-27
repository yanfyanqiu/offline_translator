// ui/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/onboarding/onboarding_bloc.dart';
import '../../core/theme.dart';
import '../../core/locale.dart';
import 'model_loading_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  String get _lang => 'zh';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (ctx, state) {
          if (state is DownloadingModels && state.downloadedCount >= 3) {
            Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) => const ModelLoadingScreen()));
          } else if (state is OnboardingError) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppTheme.errorRed));
          }
        },
        builder: (ctx, state) {
          final isDownloading = state is DownloadingModels;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(children: [
                const Spacer(),
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.primaryPink]),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(Icons.translate, size: 64, color: Colors.white),
                ),
                const SizedBox(height: 32),
                Text(AppLocale.t(_lang,'download_title'), style: const TextStyle(color: AppTheme.textWhite, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(AppLocale.t(_lang,'download_subtitle'), style: const TextStyle(color: AppTheme.textGray, fontSize: 14), textAlign: TextAlign.center),
                const SizedBox(height: 40),
                _modelCard(ctx,'🎙 语音识别','whisper-small.gguf',_getProgress(state,'ASR'),isDownloading),
                const SizedBox(height:12),
                _modelCard(ctx,'🔄 翻译模型','HY-MT1.5-1.8B-q5_k_m.gguf',_getProgress(state,'MT'),isDownloading),
                const SizedBox(height:12),
                _modelCard(ctx,'🔊 语音合成','neutts-air-Q4_0.gguf',_getProgress(state,'TTS'),isDownloading),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    Row(children: [
                      const Icon(Icons.tips_and_updates, color: AppTheme.warnOrange, size:20),
                      const SizedBox(width:8), const Text('温馨提示', style: TextStyle(color: AppTheme.warnOrange, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height:8),
                    Text('建议在 Wi-Fi 下下载，节省流量', style: const TextStyle(color: AppTheme.textGray, fontSize:13)),
                    const SizedBox(height:4),
                    Text('离线翻译无网络限制，保护隐私', style: const TextStyle(color: AppTheme.textGray, fontSize:13)),
                  ]),
                ),
                const SizedBox(height:24),
                if (!isDownloading)
                  SizedBox(width:double.infinity, child: ElevatedButton.icon(
                    onPressed:() => context.read<OnboardingBloc>().add(StartDownload()),
                    icon: const Icon(Icons.download), label: Text(AppLocale.t(_lang,'btn_download')),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, padding: const EdgeInsets.symmetric(vertical:16)),
                  ))
                else _buildProgress(state as DownloadingModels),
                const SizedBox(height:40),
              ]),
            ),
          );
        },
      ),
    );
  }

  double _getProgress(OnboardingState s, String model) {
    if (s is DownloadingModels) {
      if (s.currentModel == model) return s.progress;
      final order = ['ASR','MT','TTS'];
      final ci = order.indexOf(s.currentModel);
      final mi = order.indexOf(model);
      if (mi < ci) return 1.0;
    }
    return 0.0;
  }

  Widget _modelCard(BuildContext ctx, String title, String file, double progress, bool downloading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:16, vertical:12),
      decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(width:40,height:40,decoration:BoxDecoration(color:AppTheme.primaryBlue.withOpacity(0.2),borderRadius:BorderRadius.circular(10)),
          child: const Icon(Icons.description, color:AppTheme.primaryBlue, size:20)),
        const SizedBox(width:12),
        Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Text(title, style: const TextStyle(color:AppTheme.textWhite, fontWeight:FontWeight.w600)),
          Text(file, style: const TextStyle(color:AppTheme.textGray, fontSize:11), overflow:TextOverflow.ellipsis),
          if (downloading && progress>0) ...[const SizedBox(height:6), ClipRRect(borderRadius:BorderRadius.circular(4), child:LinearProgressIndicator(value:progress, minHeight:4))],
        ])),
        if (!downloading) const Icon(Icons.circle_outlined, color:AppTheme.textGray, size:16)
        else if (progress>=1.0) const Icon(Icons.check_circle, color:AppTheme.successGreen, size:20)
        else const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2)),
      ]),
    );
  }

  Widget _buildProgress(DownloadingModels s) {
    final speedMB = (s.bytesPerSecond/1024/1024).toStringAsFixed(1);
    return Column(children:[
      Row(mainAxisAlignment:MainAxisAlignment.center, children:[
        const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2,color:AppTheme.primaryBlue)),
        const SizedBox(width:8),
        Text('下载中: ${s.currentModel} ${(s.progress*100).toStringAsFixed(0)}%', style: const TextStyle(color:AppTheme.textWhite)),
      ]),
      if (s.bytesPerSecond>0) ...[const SizedBox(height:4), Text('$speedMB MB/s', style:const TextStyle(color:AppTheme.textGray,fontSize:12))],
    ]);
  }
}
