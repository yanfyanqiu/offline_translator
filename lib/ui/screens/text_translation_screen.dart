// ui/screens/text_translation_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class TextTranslationScreen extends StatefulWidget {
  const TextTranslationScreen({super.key});
  @override State<TextTranslationScreen> createState() => _TextTranslationScreenState();
}
class _TextTranslationScreenState extends State<TextTranslationScreen> {
  final _ctrl = TextEditingController();
  String _src='zh',_tgt='en',_result='';
  bool _loading=false;
  final _names={'zh':'中文','en':'English','ja':'日本語','ko':'한국어','fr':'Français'};

  Future<void> _translate() async {
    if(_ctrl.text.trim().isEmpty) return;
    setState(()=>_loading=true);
    await Future.delayed(const Duration(milliseconds:800));
    setState((){_result=_ctrl.text.contains('你好')?'Hello':'【译文】${_ctrl.text}';_loading=false;});
  }
  @override Widget build(BuildContext context)=>Scaffold(
    backgroundColor:AppTheme.bgDark,
    appBar:AppBar(backgroundColor:AppTheme.bgDark,title:const Text('文本翻译',style:TextStyle(color:AppTheme.textWhite)),centerTitle:true,
      leading:Padding(padding:const EdgeInsets.all(8),child:Container(width:36,height:36,decoration:BoxDecoration(color:AppTheme.primaryBlue.withOpacity(0.2),borderRadius:BorderRadius.circular(10)),
        child:const Icon(Icons.text_fields,color:AppTheme.primaryBlue,size:20)))),
    body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[
      Row(children:[_langChip(_src,true),IconButton(onPressed:()=>setState((){var t=_src;_src=_tgt;_tgt=t;}),icon:const Icon(Icons.swap_horiz,color:AppTheme.primaryBlue)),_langChip(_tgt,false),const Spacer()]),
      const SizedBox(height:12),
      Expanded(flex:2,child:Container(decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(16),border:Border.all(color:AppTheme.dividerColor)),
        child:TextField(controller:_ctrl,maxLines:null,expands:true,style:const TextStyle(color:AppTheme.textWhite,fontSize:16),
          decoration:InputDecoration(hintText:'输入要翻译的文字...',hintStyle:const TextStyle(color:AppTheme.textGray),border:InputBorder.none,contentPadding:const EdgeInsets.all(16),
            suffixIcon:_ctrl.text.isNotEmpty?IconButton(onPressed:(){_ctrl.clear();setState(()=>_result='');},icon:const Icon(Icons.clear,color:AppTheme.textGray)):null),
          onChanged:(_)=>setState((){})))),
      const SizedBox(height:8),
      SizedBox(width:double.infinity,child:ElevatedButton(onPressed:_ctrl.text.isEmpty||_loading?null:_translate,
        style:ElevatedButton.styleFrom(backgroundColor:AppTheme.primaryBlue,padding:const EdgeInsets.symmetric(vertical:14)),
        child:_loading?const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)):const Text('翻译'))),
      const SizedBox(height:12),
      Expanded(flex:2,child:Container(decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(16),border:Border.all(color:AppTheme.primaryPink.withOpacity(0.3))),
        padding:const EdgeInsets.all(16),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[const Icon(Icons.auto_awesome,color:AppTheme.primaryPink,size:16),const SizedBox(width:6),const Text('译文',style:TextStyle(color:AppTheme.primaryPink,fontWeight:FontWeight.w600,fontSize:13)),const Spacer(),
            if(_result.isNotEmpty)...[IconButton(onPressed:(){},icon:const Icon(Icons.copy,color:AppTheme.textGray,size:18),padding:EdgeInsets.zero,constraints:const BoxConstraints()),
              IconButton(onPressed:(){},icon:const Icon(Icons.volume_up,color:AppTheme.textGray,size:18),padding:EdgeInsets.zero,constraints:const BoxConstraints())]]),
          Expanded(child:SingleChildScrollView(child:Text(_result.isEmpty?'译文将显示在这里':_result,style:TextStyle(color:_result.isEmpty?AppTheme.textGray:AppTheme.textWhite,fontSize:16,height:1.5)))),
        ]))),
    ])));
  }
  Widget _langChip(String code,bool src)=>GestureDetector(
    onTap:()=>_showPicker(src),
    child:Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6),decoration:BoxDecoration(color:(src?AppTheme.primaryPink:AppTheme.primaryBlue).withOpacity(0.15),borderRadius:BorderRadius.circular(20),border:Border.all(color:(src?AppTheme.primaryPink:AppTheme.primaryBlue).withOpacity(0.4))),
      child:Row(mainAxisSize:MainAxisSize.min,children:[Text(_names[code]??code,style:TextStyle(color:src?AppTheme.primaryPink:AppTheme.primaryBlue,fontSize:13)),const SizedBox(width:4),Icon(Icons.arrow_drop_down,color:src?AppTheme.primaryPink:AppTheme.primaryBlue,size:18)])));
  void _showPicker(bool src){
    final cur=src?_src:_tgt;
    showModalBottomSheet(context:context,backgroundColor:AppTheme.cardDark,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(20))),
      builder:(ctx)=>ListView(shrinkWrap:true,children:(_names.keys.toList()..sort()).map((code)=>ListTile(
        title:Text(_names[code]!,style:const TextStyle(color:AppTheme.textWhite)),
        trailing:code==cur?const Icon(Icons.check,color:AppTheme.primaryPink):null,
        onTap:(){setState((){if(src)_src=code;else _tgt=code;});Navigator.pop(ctx);},
      )).toList()));
  }
}
