// ui/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../../core/locale.dart';
import '../../blocs/settings/settings_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  String get _lang => 'zh';
  @override Widget build(BuildContext context) =>Scaffold(
    backgroundColor:AppTheme.bgDark,
    appBar:AppBar(backgroundColor:AppTheme.bgDark,title:Text(AppLocale.t(_lang,'profile_tab'),style:TextStyle(color:AppTheme.textWhite)),centerTitle:true),
    body:BlocBuilder<SettingsBloc,SettingsState>(
      builder:(ctx,st)=>SingleChildScrollView(
        padding:const EdgeInsets.all(16),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          // 用户卡片
          Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(gradient:LinearGradient(colors:[AppTheme.primaryBlue.withOpacity(0.3),AppTheme.primaryPink.withOpacity(0.3)],begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(20)),
            child:Row(children:[
              Container(width:60,height:60,decoration:BoxDecoration(color:AppTheme.cardDark,shape:BoxShape.circle,border:Border.all(color:AppTheme.primaryBlue,width:2)),
                child:const Icon(Icons.person,color:AppTheme.primaryBlue,size:32)),
              const SizedBox(width:16),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                const Text('游客用户',style:TextStyle(color:AppTheme.textWhite,fontSize:18,fontWeight:FontWeight.w600)),const SizedBox(height:4),
                Row(children:[Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:2),decoration:BoxDecoration(color:AppTheme.warnOrange.withOpacity(0.2),borderRadius:BorderRadius.circular(10)),
                  child:const Text('免费剩余 2 小时',style:TextStyle(color:AppTheme.warnOrange,fontSize:11)))])])),
            ])),
          const SizedBox(height:24),
          _section(AppLocale.t(_lang,'settings'),[
            _settingRow(Icons.speed,AppLocale.t(_lang,'settings_speed'),'${st.speed.toStringAsFixed(1)}x',
              SizedBox(width:160,child:Slider(value:st.speed,min:0.5,max:2.0,divisions:15,onChanged:(v)=>ctx.read<SettingsBloc>().add(UpdateSpeed(v)))),
              Icons.chevron_right,onTap:null),
            _settingRow(Icons.volume_up,AppLocale.t(_lang,'settings_volume'),'${(st.volume*100).round()}%',
              SizedBox(width:160,child:Slider(value:st.volume,min:0.0,max:1.0,onChanged:(v)=>ctx.read<SettingsBloc>().add(UpdateVolume(v)))),
              Icons.chevron_right,onTap:null),
            _settingRow(Icons.record_voice_over,AppLocale.t(_lang,'settings_voice'),st.voiceName,Icons.chevron_right,onTap:()=>_showVoices(ctx,st)),
            _settingRow(Icons.language,AppLocale.t(_lang,'settings_default_lang'),'中↔英（默认）',Icons.chevron_right,onTap:null),
            _settingRow(Icons.play_circle_outline,'自动播放译文',st.autoPlay?'开启':'关闭',
              Switch(value:st.autoPlay,activeColor:AppTheme.primaryBlue,onChanged:(v)=>ctx.read<SettingsBloc>().add(UpdateAutoPlay(v))),
              null,onTap:null),
          ]),
          const SizedBox(height:24),
          _section('账户',[
            _settingRow(Icons.person_add,AppLocale.t(_lang,'register'),'',Icons.chevron_right,onTap:null),
            _settingRow(Icons.login,AppLocale.t(_lang,'login'),'',Icons.chevron_right,onTap:null),
            _settingRow(Icons.workspace_premium,AppLocale.t(_lang,'purchase'),AppLocale.t(_lang,'free_usage'),
              Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6),decoration:BoxDecoration(color:AppTheme.warnOrange.withOpacity(0.2),borderRadius:BorderRadius.circular(20)),
                child:const Text('VIP',style:TextStyle(color:AppTheme.warnOrange,fontWeight:FontWeight.bold,fontSize:12))),Icons.chevron_right,onTap:null),
          ]),
          const SizedBox(height:24),
          _section('关于',[
            _settingRow(Icons.info_outline,'版本信息','v1.0.0',const SizedBox(),onTap:null),
          ]),
          const SizedBox(height:40),
        ]))));
  Widget _section(String title,List<Widget> rows)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(title,style:const TextStyle(color:AppTheme.textGray,fontSize:13,fontWeight:FontWeight.w600,letterSpacing:1)),
    const SizedBox(height:12),
    ...rows.map((r)=>Padding(padding:const EdgeInsets.only(bottom:8),child:r)),
  ]);
  Widget _settingRow(IconData icon,String title,String subtitle,Widget trailing,VoidCallback? onTap)=>GestureDetector(
    onTap:onTap,behavior:HitTestBehavior.opaque,
    child:Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(14)),
      child:Row(children:[
        Container(width:36,height:36,decoration:BoxDecoration(color:AppTheme.primaryBlue.withOpacity(0.15),borderRadius:BorderRadius.circular(10)),
          child:Icon(icon,color:AppTheme.primaryBlue,size:18)),
        const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(color:AppTheme.textWhite,fontSize:14)),if(subtitle.isNotEmpty)Text(subtitle,style:TextStyle(color:AppTheme.textGray,fontSize:12))])),
        trailing,
      ])));
  void _showVoices(BuildContext ctx,SettingsState st)=>showModalBottomSheet(
    context:ctx,backgroundColor:AppTheme.cardDark,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(20))),
    builder:(bctx)=>Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
      const Text('选择音色',style:TextStyle(color:AppTheme.textWhite,fontSize:18,fontWeight:FontWeight.w600)),const SizedBox(height:16),
      ...[('女声-温柔',0),('男声-磁性',1),('童声-活泼',2)].map((item)=>ListTile(
        leading:Container(width:36,height:36,decoration:BoxDecoration(color:st.voiceId==item.$2?AppTheme.primaryPink.withOpacity(0.2):AppTheme.dividerColor,shape:BoxShape.circle),
          child:Icon(Icons.record_voice_over,color:st.voiceId==item.$2?AppTheme.primaryPink:AppTheme.textGray,size:18)),
        title:Text(item.$1,style:const TextStyle(color:AppTheme.textWhite)),
        trailing:st.voiceId==item.$2?const Icon(Icons.check,color:AppTheme.primaryPink):null,
        onTap:(){ctx.read<SettingsBloc>().add(UpdateVoice(item.$2,item.$1));Navigator.pop(bctx);},
      )),
    ])));
}
