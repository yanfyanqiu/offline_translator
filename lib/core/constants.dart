// core/constants.dart
class AppConstants {
  AppConstants._();

  static const String appName = '离线翻译';
  static const String appVersion = '1.0.0';

  static const String asrModelUrl =
      'https://huggingface.co/buckets/andyang/whisper-small/resolve/whisper-small.gguf?download=true';
  static const String mtModelUrl =
      'https://huggingface.co/buckets/andyang/q5/resolve/HY-MT1.5-1.8B-q5_k_m.gguf?download=true';
  static const String ttsModelUrl =
      'https://huggingface.co/buckets/andyang/neutts-air-Q4_0/resolve/neutts-air-Q4_0.gguf?download=true';

  static const String asrModelFileName = 'whisper-small.gguf';
  static const String mtModelFileName = 'HY-MT1.5-1.8B-q5_k_m.gguf';
  static const String ttsModelFileName = 'neutts-air-Q4_0.gguf';
  static const String modelsDir = 'models';

  static const int asrSampleRate = 16000;
  static const int ttsSampleRate = 24000;
  static const int silenceTimeoutSeconds = 3;

  static const double minSpeed = 0.5, maxSpeed = 2.0, defaultSpeed = 1.0;
  static const double minVolume = 0.0, maxVolume = 1.0, defaultVolume = 1.0;
  static const int freeUsageMinutes = 120;

  static const List<String> supportedLanguages = [
    'zh','en','ja','ko','fr','de','es','it','pt','ru','ar','th','vi','id','ms',
  ];
  static const Map<String, String> languageNames = {
    'zh':'中文','en':'English','ja':'日本語','ko':'한국어','fr':'Français',
    'de':'Deutsch','es':'Español','it':'Italiano','pt':'Português','ru':'Русский',
    'ar':'العربية','th':'ภาษาไทย','vi':'Tiếng Việt','id':'Bahasa Indonesia','ms':'Bahasa Melayu',
  };
}
