// core/locale.dart
class AppLocale {
  AppLocale._();
  static const Map<String, Map<String, String>> _s = {
    'zh': {
      'app_name':'离线翻译','download_title':'下载离线翻译包','btn_download':'开始下载',
      'loading_asr':'加载语音识别模型...','loading_mt':'加载翻译模型...',
      'loading_tts':'加载语音合成模型...','loading_done':'加载完成',
      'voice_tab':'语音翻译','text_tab':'文本翻译','camera_tab':'拍照翻译',
      'word_tab':'背单词','profile_tab':'我的',
      'btn_speak':'按住说话','lang_chinese':'中文','lang_english':'English',
      'simultaneous':'同声传译','settings':'设置','free_usage':'免费使用 2 小时',
      'no_result':'未识别到内容，请重试','word_empty':'暂无单词',
    },
    'en': {
      'app_name':'Offline Translator','download_title':'Download Offline Package','btn_download':'Start Download',
      'loading_asr':'Loading ASR model...','loading_mt':'Loading translation model...',
      'loading_tts':'Loading TTS model...','loading_done':'Loading complete',
      'voice_tab':'Voice','text_tab':'Text','camera_tab':'Camera',
      'word_tab':'Words','profile_tab':'Profile',
      'btn_speak':'Hold to Speak','lang_chinese':'Chinese','lang_english':'English',
      'simultaneous':'Simultaneous','settings':'Settings','free_usage':'Free 2 Hours',
      'no_result':'No speech detected','word_empty':'No words yet',
    },
  };
  static String t(String lang, String key) => _s[lang]?[key] ?? _s['en']![key] ?? key;
}
