// ui/screens/voice_translation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/translation/translation_bloc.dart';
import '../../core/theme.dart';
import '../../core/locale.dart';
import '../../models/language.dart';
import '../widgets/voice_button.dart';
import 'simultaneous_screen.dart';

class VoiceTranslationScreen extends StatelessWidget {
  const VoiceTranslationScreen({super.key});
  String get _lang => 'zh';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        title: Text(AppLocale.t(_lang,'voice_tab'), style:const TextStyle(color:AppTheme.textWhite,fontSize:18)),
        centerTitle:true,
        leading:Padding(
          padding:const EdgeInsets.all(8),
          child:Container(width:36,height:36,
            decoration:BoxDecoration(color:AppTheme.primaryBlue.withOpacity(0.2),borderRadius:BorderRadius.circular(10)),
            child:const Icon(Icons.translate,color:AppTheme.primaryBlue,size:20)),
        ),
        leadingWidth:52,
        actions:[
          IconButton(
            onPressed:()=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>const SimultaneousScreen())),
            icon:Container(padding:const EdgeInsets.all(6),
              decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(8)),
              child:const Icon(Icons.hearing,color:AppTheme.primaryPink,size:20)),
          ),
          const SizedBox(width:8),
        ],
      ),
      body: BlocBuilder<TranslationBloc,TranslationState>(
        builder:(context,state){
          return Column(children:[
            // 英文区
            Expanded(child:_langArea(context,
              lang:Language.fromCode(state.targetLang),text:_getText(state,false),
              color:AppTheme.primaryBlue,isSource:false,
              onPlay:()=>context.read<TranslationBloc>().add(PlayTranslatedAudio(state is TranslationDone?state.result.translatedText:'')),
            )),
            // 分割线
            _buildDivider(context,state),
            // 中文区
            Expanded(child:_langArea(context,
              lang:Language.fromCode(state.sourceLang),text:_getText(state,true),
              color:AppTheme.primaryPink,isSource:true,
              onPlay:()=>context.read<TranslationBloc>().add(PlaySourceAudio(state is TranslationDone?state.result.sourceText:'')),
            )),
            // 底部按钮
            _buildBottomButtons(context,state),
            const SizedBox(height:16),
          ]);
        },
      ),
    );
  }

  String _getText(TranslationState s,bool isSource){
    if(s is TranslationDone) return isSource?s.result.sourceText:s.result.translatedText;
    if(s is TranslationRecording) return isSource?'🎤 说话中...':'';
    if(s is TranslationProcessing && s.phase=='translating') return isSource?'':'翻译中...';
    return '';
  }

  Widget _langArea(BuildContext ctx,{required Language lang,required String text,required Color color,required bool isSource,required VoidCallback onPlay}){
    return Container(
      margin:EdgeInsets.fromLTRB(16,isSource?8:16,16,isSource?16:8),
      decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(20),border:Border.all(color:color.withOpacity(0.3),width:1)),
      child:Column(children:[
        Container(
          padding:const EdgeInsets.symmetric(horizontal:16,vertical:8),
          decoration:BoxDecoration(color:color.withOpacity(0.15),borderRadius:const BorderRadius.vertical(top:Radius.circular(19))),
          child:Row(children:[
            Text('${lang.flag??''} ${lang.name}',style:TextStyle(color:color,fontWeight:FontWeight.w600,fontSize:13)),
            const Spacer(),
            if(text.isNotEmpty) GestureDetector(onTap:onPlay,child:Icon(Icons.volume_up,color:color.withOpacity(0.6),size:20)),
          ]),
        ),
        Expanded(child:Center(child:SingleChildScrollView(
          padding:const EdgeInsets.all(20),
          child:Text(text.isEmpty?(isSource?AppLocale.t(_lang,'btn_speak'):'译文将显示在这里'):text,
            style:TextStyle(color:text.isEmpty?AppTheme.textGray:AppTheme.textWhite,fontSize:text.isEmpty?14:20,height:1.5),
            textAlign:TextAlign.center),
        ))),
      ]),
    );
  }

  Widget _buildDivider(BuildContext ctx,TranslationState state){
    final recording = state is TranslationRecording;
    return GestureDetector(
      onTap:()=>ctx.read<TranslationBloc>().add(SwitchDirection()),
      child:Container(
        height:60,alignment:Alignment.center,
        child:Stack(alignment:Alignment.center,children:[
          Container(height:1,margin:const EdgeInsets.symmetric(horizontal:16),color:AppTheme.dividerColor),
          AnimatedContainer(
            duration:const Duration(milliseconds:300),
            width:56,height:56,
            decoration:BoxDecoration(
              gradient:LinearGradient(colors:recording?[AppTheme.warnOrange,AppTheme.warnOrange]:[AppTheme.primaryBlue,AppTheme.primaryPink]),
              borderRadius:BorderRadius.circular(28),
              boxShadow:[BoxShadow(color:(recording?AppTheme.warnOrange:AppTheme.primaryBlue).withOpacity(0.4),blurRadius:12,offset:const Offset(0,4))],
            ),
            child:const Icon(Icons.swap_vert,color:Colors.white,size:28),
          ),
        ]),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext ctx,TranslationState state){
    final recording = state is TranslationRecording;
    final processing = state is TranslationProcessing;
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal:32),
      child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
        VoiceButton(label:'English',color:AppTheme.primaryBlue,isRecording:false,isProcessing:processing,
          onPressed:(){
            ctx.read<TranslationBloc>().add(SelectLanguage('en','zh'));
            if(!recording&&!processing) ctx.read<TranslationBloc>().add(StartRecording('en'));
          },
          onReleased:(){ if(recording) ctx.read<TranslationBloc>().add(StopRecording()); }),
        _buildMic(ctx,recording,processing),
        VoiceButton(label:'中文',color:AppTheme.primaryPink,isRecording:false,isProcessing:processing,
          onPressed:(){
            ctx.read<TranslationBloc>().add(SelectLanguage('zh','en'));
            if(!recording&&!processing) ctx.read<TranslationBloc>().add(StartRecording('zh'));
          },
          onReleased:(){ if(recording) ctx.read<TranslationBloc>().add(StopRecording()); }),
      ]),
    );
  }

  Widget _buildMic(BuildContext ctx,bool recording,bool processing){
    return GestureDetector(
      onTap:processing?null:(){ if(!recording) ctx.read<TranslationBloc>().add(StartRecording('zh')); },
      onLongPressEnd:recording?(_)=>ctx.read<TranslationBloc>().add(StopRecording()):null,
      child:AnimatedContainer(
        duration:const Duration(milliseconds:200),
        width:recording?72:64,height:recording?72:64,
        decoration:BoxDecoration(
          color:recording?AppTheme.errorRed:AppTheme.cardDark,
          borderRadius:BorderRadius.circular(36),
          border:Border.all(color:recording?AppTheme.errorRed:AppTheme.dividerColor,width:2),
          boxShadow:recording?[BoxShadow(color:AppTheme.errorRed.withOpacity(0.4),blurRadius:16,spreadRadius:2)]:null,
        ),
        child:Icon(processing?Icons.hourglass_empty:(recording?Icons.stop:Icons.mic),color:recording?Colors.white:AppTheme.textGray,size:28),
      ),
    );
  }
}
