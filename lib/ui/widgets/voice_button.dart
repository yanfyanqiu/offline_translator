// ui/widgets/voice_button.dart
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class VoiceButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isRecording;
  final bool isProcessing;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  const VoiceButton({
    super.key,
    required this.label,
    required this.color,
    required this.isRecording,
    required this.isProcessing,
    required this.onPressed,
    required this.onReleased,
  });

  @override
  Widget build(BuildContext context) => Column(mainAxisSize:MainAxisSize.min,children:[
    GestureDetector(
      onTap: isProcessing ? null : onPressed,
      onLongPressEnd: (_) => onReleased(),
      child: AnimatedContainer(
        duration:const Duration(milliseconds:150),
        width:80,height:40,
        decoration:BoxDecoration(
          color: isRecording ? color : color.withOpacity(0.15),
          borderRadius:BorderRadius.circular(20),
          border:Border.all(color:color, width:isRecording?2:1.5),
          boxShadow: isRecording?[BoxShadow(color:color.withOpacity(0.4),blurRadius:12,spreadRadius:2)]:null,
        ),
        child:Center(child: isProcessing
          ? SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:color))
          : Icon(isRecording?Icons.stop:Icons.mic, color:isRecording?Colors.white:color, size:20)),
      ),
    ),
    const SizedBox(height:6),
    Text(label,style:TextStyle(color:isRecording?color:AppTheme.textGray,fontSize:11,fontWeight:FontWeight.w500)),
  ]);
}
