// ui/screens/word_learning_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/locale.dart';
import 'package:uuid/uuid.dart';

class WordItem {
  final String id, word, translation;
  WordItem(this.id, this.word, this.translation);
}

class WordLearningScreen extends StatefulWidget {
  const WordLearningScreen({super.key});
  @override State<WordLearningScreen> createState() => _WordLearningScreenState();
}
class _WordLearningScreenState extends State<WordLearningScreen> {
  final _uuid = const Uuid();
  final _wordCtrl = TextEditingController();
  List<String> _lists = ['列表1','列表2'];
  String? _curList;
  Map<String,List<WordItem>> _words = {};
  bool _playing = false;

  String get _lang => 'zh';
  @override Widget build(BuildContext context) =>Scaffold(
    backgroundColor:AppTheme.bgDark,
    appBar:AppBar(backgroundColor:AppTheme.bgDark,title:const Text('背单词',style:TextStyle(color:AppTheme.textWhite)),centerTitle:true,
      leading:Padding(padding:const EdgeInsets.all(8),child:Container(width:36,height:36,decoration:BoxDecoration(color:AppTheme.primaryPink.withOpacity(0.2),borderRadius:BorderRadius.circular(10)),
        child:const Icon(Icons.book,color:AppTheme.primaryPink,size:20)))),
    body:_curList==null?_buildLists():_buildWords(),
    floatingActionButton:_curList!=null?FloatingActionButton(backgroundColor:AppTheme.primaryPink,onPressed:()=>_addWord(),child:const Icon(Icons.add,color:Colors.white)):null,
  );

  Widget _buildLists() =>Column(children:[
    Container(margin:const EdgeInsets.all(16),padding:const EdgeInsets.all(16),decoration:BoxDecoration(gradient:LinearGradient(colors:[AppTheme.primaryPink.withOpacity(0.2),AppTheme.primaryBlue.withOpacity(0.2)]),borderRadius:BorderRadius.circular(16)),
      child:Row(children:[
        const Icon(Icons.translate,color:AppTheme.textGray,size:20),const SizedBox(width:12),
        Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('学习模式',style:TextStyle(color:AppTheme.textWhite,fontWeight:FontWeight.w600)),const SizedBox(height:4),
          Text('🇨🇳 中文 → 🇺🇸 English',style:TextStyle(color:AppTheme.textGray,fontSize:12)),
        ]),
      ])),
    Expanded(child:_lists.isEmpty?Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
      const Icon(Icons.playlist_add,color:AppTheme.textGray,size:64),const SizedBox(height:16),
      Text(AppLocale.t(_lang,'word_empty'),style:TextStyle(color:AppTheme.textGray,fontSize:16)),
      const SizedBox(height:24),
      ElevatedButton.icon(icon:const Icon(Icons.add),label:const Text('新建播放列表'),style:ElevatedButton.styleFrom(backgroundColor:AppTheme.primaryPink,padding:const EdgeInsets.symmetric(horizontal:24,vertical:12)),onPressed:_newList),
    ]):ListView.builder(padding:const EdgeInsets.symmetric(horizontal:16),itemCount:_lists.length,itemBuilder:(_,i)=>_listCard(_lists[i]))),
    Padding(padding:const EdgeInsets.all(16),child: SizedBox(width:double.infinity,child:OutlinedButton.icon(icon:const Icon(Icons.add),label:const Text('新建播放列表'),onPressed:_newList))),
  ]);

  Widget _listCard(String name) =>GestureDetector(
    onTap:()=>setState((){_curList=name;_words[name]??=[];}),
    child:Container(margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(16)),
      child:Row(children:[
        Container(width:48,height:48,decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppTheme.primaryPink,AppTheme.primaryBlue]),borderRadius:BorderRadius.circular(12)),
          child:const Icon(Icons.playlist_play,color:Colors.white,size:24)),
        const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(name,style:const TextStyle(color:AppTheme.textWhite,fontWeight:FontWeight.w600)),const SizedBox(height:2),
          Text('${_words[name]?.length??0} 个单词',style:TextStyle(color:AppTheme.textGray,fontSize:12)),
        ])),const Icon(Icons.chevron_right,color:AppTheme.textGray),
      ])));

  Widget _buildWords()=>Column(children:[
    Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),child:Row(children:[
      IconButton(onPressed:()=>setState(()=>_curList=null),icon:const Icon(Icons.arrow_back,color:AppTheme.textWhite)),
      Expanded(child:Text(_curList!,style:const TextStyle(color:AppTheme.textWhite,fontSize:18,fontWeight:FontWeight.w600))),
      IconButton(onPressed:_mergeList,icon:const Icon(Icons.merge_type,color:AppTheme.textGray,size:20)),
      IconButton(onPressed:_deleteList,icon:const Icon(Icons.delete_outline,color:AppTheme.errorRed,size:20)),
    ])),
    if((_words[_curList]??[]).isNotEmpty)Container(margin:const EdgeInsets.symmetric(horizontal:16,vertical:8),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(16),border:Border.all(color:AppTheme.primaryPink.withOpacity(0.3))),
      child:Column(children:[
        Text(_playing?'播放中':'点击播放开始学习',style:const TextStyle(color:AppTheme.textWhite,fontSize:16)),
        const SizedBox(height:12),
        Row(mainAxisAlignment:MainAxisAlignment.center,children:[
          IconButton(onPressed:()=>setState(()=>_playing=false),icon:const Icon(Icons.stop,color:AppTheme.textGray)),
          const SizedBox(width:8),
          GestureDetector(onTap:()=>setState(()=>_playing=!_playing),
            child:Container(width:64,height:64,decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppTheme.primaryPink,AppTheme.primaryBlue]),shape:BoxShape.circle,boxShadow:[BoxShadow(color:AppTheme.primaryPink.withOpacity(0.4),blurRadius:12)]),
              child:Icon(_playing?Icons.pause:Icons.play_arrow,color:Colors.white,size:32))),
          const SizedBox(width:8),
          IconButton(onPressed:(){},icon:const Icon(Icons.skip_next,color:AppTheme.textGray)),
        ]),
      ])),
    Expanded(child:(_words[_curList]??[]).isEmpty?const Center(child:Text('暂无单词，点击 + 添加',style:TextStyle(color:AppTheme.textGray)):ListView.builder(padding:const EdgeInsets.symmetric(horizontal:16),itemCount:_words[_curList]!.length,
      itemBuilder:(_,i)=>_wordCard(_words[_curList]![i]))),
  ]);

  Widget _wordCard(WordItem w)=>Container(
    key:ValueKey(w.id),margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:AppTheme.cardDark,borderRadius:BorderRadius.circular(12)),
    child:Row(children:[
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(w.word,style:const TextStyle(color:AppTheme.textWhite,fontWeight:FontWeight.w600)),const SizedBox(height:2),Text(w.translation,style:TextStyle(color:AppTheme.textGray,fontSize:12))])),
      IconButton(onPressed:()=>_deleteWord(w),icon:const Icon(Icons.delete_outline,color:AppTheme.errorRed,size:18)),
    ]));

  void _newList(){
    final tc=TextEditingController();
    showDialog(context:context,builder:(ctx)=>AlertDialog(backgroundColor:AppTheme.cardDark,title:const Text('新建播放列表',style:TextStyle(color:AppTheme.textWhite)),
      content:TextField(controller:tc,style:const TextStyle(color:AppTheme.textWhite),decoration:const InputDecoration(hintText:'列表名称')),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('取消')),ElevatedButton(onPressed:(){if(tc.text.isNotEmpty)setState((){_lists.add(tc.text);});Navigator.pop(ctx);},child:const Text('创建'))]));
  }
  void _addWord(){
    _wordCtrl.clear();
    showDialog(context:context,builder:(ctx)=>AlertDialog(backgroundColor:AppTheme.cardDark,title:const Text('添加单词',style:TextStyle(color:AppTheme.textWhite)),
      content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:_wordCtrl,style:const TextStyle(color:AppTheme.textWhite),decoration:const InputDecoration(hintText:'输入单词（中文）')),
        const SizedBox(height:8),const Text('将在目标语言中翻译并播放',style:TextStyle(color:AppTheme.textGray,fontSize:12))]),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('取消')),
        ElevatedButton(onPressed:(){if(_wordCtrl.text.isNotEmpty)setState(()=>_words[_curList!]!.add(WordItem(_uuid.v4(),_wordCtrl.text,'【译文】${_wordCtrl.text}')));Navigator.pop(ctx);},child:const Text('添加并翻译'))]));
  }
  void _deleteList(){
    showDialog(context:context,builder:(ctx)=>AlertDialog(backgroundColor:AppTheme.cardDark,title:const Text('删除列表',style:TextStyle(color:AppTheme.textWhite)),
      content:Text('确定删除 "$_curList" 吗？',style:TextStyle(color:AppTheme.textGray)),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('取消')),ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:AppTheme.errorRed),onPressed:(){setState((){_lists.remove(_curList);_curList=null;});Navigator.pop(ctx);},child:const Text('删除'))]));
  }
  void _deleteWord(WordItem w){setState(()=>_words[_curList!]!.remove(w));}
  void _mergeList(){
    showDialog(context:context,builder:(ctx)=>AlertDialog(backgroundColor:AppTheme.cardDark,title:const Text('合并列表',style:TextStyle(color:AppTheme.textWhite)),
      content:const Text('选择一个列表合并到当前列表',style:TextStyle(color:AppTheme.textGray)),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('取消')),ElevatedButton(onPressed:()=>Navigator.pop(ctx),child:const Text('合并'))]));
  }
}
