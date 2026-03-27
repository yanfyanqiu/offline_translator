// ui/widgets/translation_bubble.dart
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/translation_result.dart';

class TranslationBubble extends StatelessWidget {
  final TranslationResult result;
  final bool isSource;
  final Color color;
  final VoidCallback onPlaySource;
  final VoidCallback onPlayTranslated;

  const TranslationBubble({
    super.key,
    required this.result,
    required this.isSource,
    required this.color,
    required this.onPlaySource,
    required this.onPlayTranslated,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: isSource ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      if (!isSource) _playBtn(Icons.volume_down, onPlaySource),
      Flexible(child:Container(
        margin: const EdgeInsets.symmetric(horizontal:16,vertical:8),
        padding: const EdgeInsets.symmetric(horizontal:16,vertical:12),
        decoration:BoxDecoration(
          color:color.withOpacity(0.15),
          borderRadius:BorderRadius.only(
            topLeft:const Radius.circular(18),topRight:const Radius.circular(18),
            bottomLeft:Radius.circular(isSource?18:4),bottomRight:Radius.circular(isSource?4:18)),
          border:Border.all(color:color.withOpacity(0.3)),
        ),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(isSource?result.sourceText:result.translatedText,style:const TextStyle(color:AppTheme.textWhite,fontSize:16,height:1.4)),
          if(result.asrDuration!=null) Padding(padding:const EdgeInsets.only(top:4),
            child:Text('识别 ${result.asrDuration!.inMilliseconds}ms | 翻译 ${result.mtDuration?.inMilliseconds??0}ms',style:TextStyle(color:AppTheme.textGray,fontSize:10))),
        ]),
      )),
      if (isSource) _playBtn(Icons.volume_up, onPlayTranslated),
    ],
  );

  Widget _playBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap:onTap,
    child:Container(margin:const EdgeInsets.symmetric(horizontal:8),width:36,height:36,
      decoration:BoxDecoration(color:color.withOpacity(0.2),shape:BoxShape.circle),
      child:Icon(icon,color:color,size:18)),
  );
}
