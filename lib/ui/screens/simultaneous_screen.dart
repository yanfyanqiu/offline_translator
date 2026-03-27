// ui/screens/simultaneous_screen.dart
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/theme.dart';

class SimultaneousScreen extends StatefulWidget {
  const SimultaneousScreen({super.key});
  @override State<SimultaneousScreen> createState() => _SimultaneousScreenState();
}
class _SimultaneousScreenState extends State<SimultaneousScreen> {
  bool _screenOff = false;
  bool _channelA = true;
  bool _headsetMode = false;
  @override void initState(){ super.initState(); WakelockPlus.enable(); }
  @override void dispose(){ WakelockPlus.disable(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> setState(()=>_screenOff=false),
      child: Scaffold(backgroundColor:_screenOff?Colors.black:AppTheme.bgDark,
        appBar:_screenOff?null:AppBar(
          backgroundColor:AppTheme.bgDark,
          leading:IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back,color:AppTheme.textWhite)),
          title:const Text('同声传译',style:TextStyle(color:AppTheme.textWhite)),
          centerTitle:true,
          actions:[
            IconButton(onPressed:(){},icon:const Icon(Icons.swap_horiz,color:AppTheme.primaryBlue)),
            IconButton(onPressed:()=>setState(()=>_screenOff=true),icon:Container(padding:const EdgeInsets.all(6),decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(8)),child:const Icon(Icons.visibility_off,color:AppTheme.textGray,size:18))),
            IconButton(onPressed:()=>setState(()=>_headsetMode=!_headsetMode),icon:Icon(_headsetMode?Icons.headphones:Icons.volume_up,color:_headsetMode?AppTheme.primaryPink:AppTheme.textGray)),
            const SizedBox(width:8),
          ],
        ),
        body:_screenOff?_buildOffView():_buildContent(),
      ),
    );
  }
  Widget _buildOffView()=>Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
    const Icon(Icons.visibility_off,color:AppTheme.textGray,size:48),const SizedBox(height:16),
    const Text('屏幕已关闭\n翻译继续运行中',style:TextStyle(color:AppTheme.textGray,fontSize:16),textAlign:TextAlign.center),
    const SizedBox(height:24),
    const Text('点击任意位置点亮屏幕',style:TextStyle(color:AppTheme.textGray,fontSize:13)),
  ]));
  Widget _buildContent()=>Column(children:[
    Padding(padding:const EdgeInsets.all(16),child:Row(children:[
      Expanded(child:_channelCard('🔊 A声道',_channelA?'中文':'英文',AppTheme.primaryPink,_channelA,()=>setState(()=>_channelA=true))),
      const SizedBox(width:12),
      Expanded(child:_channelCard('🔊 B声道',_channelA?'英文':'中文',AppTheme.primaryBlue,!_channelA,()=>setState(()=>_channelA=false))),
    ])),
    Expanded(child:_simArea('🇺🇸 English',AppTheme.primaryBlue)),
    Container(height:1,margin:const EdgeInsets.symmetric(horizontal:16),color:AppTheme.dividerColor),
    Expanded(child:_simArea('🇨🇳 中文',AppTheme.primaryPink)),
    Container(padding:const EdgeInsets.all(16),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
      Container(width:8,height:8,decoration:const BoxDecoration(color:AppTheme.successGreen,shape:BoxShape.circle)),
      const SizedBox(width:8),
      const Text('🎤 持续监听中...',style:TextStyle(color:AppTheme.successGreen,fontSize:13)),
    ])),
  ]);
  Widget _channelCard(String label,String subtitle,Color color,bool active,VoidCallback onTap)=>GestureDetector(
    onTap:onTap,
    child:AnimatedContainer(duration:const Duration(milliseconds:200),
      padding:const EdgeInsets.all(16),
      decoration:BoxDecoration(color:active?color.withOpacity(0.2):AppTheme.cardDark,borderRadius:BorderRadius.circular(16),border:Border.all(color:active?color:AppTheme.dividerColor,width:active?1.5:1)),
      child:Column(children:[Text(label,style:TextStyle(color:color,fontWeight:FontWeight.w600)),const SizedBox(height:4),Text(subtitle,style:const TextStyle(color:AppTheme.textGray,fontSize:12))]),
    ),
  );
  Widget _simArea(String label,Color color)=>Container(
    margin:const EdgeInsets.all(16),
    decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(20),border:Border.all(color:color.withOpacity(0.3))),
    child:Column(children:[
      Container(padding:const EdgeInsets.symmetric(horizontal:16,vertical:8),decoration:BoxDecoration(color:color.withOpacity(0.15),borderRadius:const BorderRadius.vertical(top:Radius.circular(19))),
        child:Row(children:[Text(label,style:TextStyle(color:color,fontWeight:FontWeight.w600,fontSize:13)),const Spacer(),Icon(Icons.volume_up,color:color.withOpacity(0.6),size:20)])),
      Expanded(child:Center(child:Text('实时翻译内容显示在此...',style:TextStyle(color:AppTheme.textGray,fontSize:14)))),
    ]),
  );
}
