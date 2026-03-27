// ui/screens/camera_translation_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../core/theme.dart';

class CameraTranslationScreen extends StatefulWidget {
  const CameraTranslationScreen({super.key});
  @override State<CameraTranslationScreen> createState() => _CameraTranslationScreenState();
}
class _CameraTranslationScreenState extends State<CameraTranslationScreen> {
  CameraController? _ctrl;
  bool _init=false,_capturing=false;
  List<String> _results=['Hello → 你好','World → 世界'];
  @override void initState(){super.initState();_initCam();}
  Future<void> _initCam()async{
    try{
      final cams=await availableCameras();if(cams.isEmpty)return;
      _ctrl=CameraController(cams.first,ResolutionPreset.medium);
      await _ctrl!.initialize();if(mounted)setState(()=>_init=true);
    }catch(_){}
  }
  @override void dispose(){_ctrl?.dispose();super.dispose();}
  Future<void> _snap()async{
    if(_ctrl==null||!_init||_capturing)return;
    setState(()=>_capturing=true);
    try{
      final img=await _ctrl!.takePicture();
      setState((){_results.addAll(['【OCR 识别中...】','APP → 应用']);});
    }catch(e){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('拍照失败:$e')));}
    finally{setState(()=>_capturing=false);}
  }
  @override Widget build(BuildContext context)=>Scaffold(
    backgroundColor:AppTheme.bgDark,
    appBar:AppBar(backgroundColor:AppTheme.bgDark,title:const Text('拍照翻译',style:TextStyle(color:AppTheme.textWhite)),centerTitle:true,
      leading:Padding(padding:const EdgeInsets.all(8),child:Container(width:36,height:36,decoration:BoxDecoration(color:AppTheme.primaryPink.withOpacity(0.2),borderRadius:BorderRadius.circular(10)),
        child:const Icon(Icons.camera_alt,color:AppTheme.primaryPink,size:20)))),
    body:Column(children:[
      Expanded(child:Container(margin:const EdgeInsets.symmetric(horizontal:16),
        decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(20)),
        child:ClipRRect(borderRadius:BorderRadius.circular(20),child:!_init?const Center(child:CircularProgressIndicator()):Stack(fit:StackFit.expand,children:[
          CameraPreview(_ctrl!),
          Center(child:Container(width:240,height:160,decoration:BoxDecoration(border:Border.all(color:AppTheme.primaryBlue,width:2),borderRadius:BorderRadius.circular(12)))),
          const Positioned(bottom:16,left:0,right:0,child:Text('将文字框在框内拍照',style:TextStyle(color:Colors.white70,fontSize:13),textAlign:TextAlign.center)),
        ])))),
      Padding(padding:const EdgeInsets.all(24),child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[
        _actionBtn(Icons.photo_library,'相册',(){}),
        GestureDetector(onTap:_init&&!_capturing?_snap:null,child:Container(width:72,height:72,
          decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppTheme.primaryBlue,AppTheme.primaryPink]),
            shape:BoxShape.circle,boxShadow:[BoxShadow(color:AppTheme.primaryBlue.withOpacity(0.4),blurRadius:16,offset:const Offset(0,4))]),
          child:const Icon(Icons.camera,color:Colors.white,size:32))),
        _actionBtn(Icons.refresh,'重拍',(){setState(()=>_results.clear());}),
      ])),
    ])));
  Widget _actionBtn(IconData icon,String label,VoidCallback onTap)=>GestureDetector(onTap:onTap,child:Column(mainAxisSize:MainAxisSize.min,children:[
    Container(width:48,height:48,decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(16)),
      child:Icon(icon,color:AppTheme.textWhite,size:22)),const SizedBox(height:4),
    Text(label,style:const TextStyle(color:AppTheme.textGray,fontSize:11)),
  ]));
}
