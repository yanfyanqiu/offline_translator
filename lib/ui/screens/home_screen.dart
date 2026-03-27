// ui/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'voice_translation_screen.dart';
import 'text_translation_screen.dart';
import 'camera_translation_screen.dart';
import 'word_learning_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _pages = [
    const VoiceTranslationScreen(),
    const TextTranslationScreen(),
    const CameraTranslationScreen(),
    const WordLearningScreen(),
    const ProfileScreen(),
  ];
  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: IndexedStack(index:_index, children:_pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color:AppTheme.cardDark, border:Border(top:BorderSide(color:AppTheme.dividerColor,width:0.5))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:8),
            child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:[
              _nav(0, Icons.mic,'语音'),
              _nav(1, Icons.text_fields,'文本'),
              _nav(2, Icons.camera_alt,'拍照'),
              _nav(3, Icons.book,'单词'),
              _nav(4, Icons.person,'我的'),
            ]),
          ),
        ),
      ),
    );
  }
  Widget _nav(int i, IconData icon, String label) {
    final active = _index==i;
    return GestureDetector(
      onTap:()=>setState(()=>_index=i),
      behavior:HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:12,vertical:4),
        child: Column(mainAxisSize:MainAxisSize.min, children:[
          Icon(icon, size:24, color:active?AppTheme.primaryBlue:AppTheme.textGray),
          const SizedBox(height:4),
          Text(label, style:TextStyle(color:active?AppTheme.primaryBlue:AppTheme.textGray,fontSize:11,fontWeight:active?FontWeight.w600:FontWeight.normal)),
        ]),
      ),
    );
  }
}
