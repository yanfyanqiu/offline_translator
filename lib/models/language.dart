// models/language.dart
import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String code;
  final String name;
  final String? flag;
  const Language({required this.code, required this.name, this.flag});
  @override List<Object?> get props => [code, name, flag];
  @override String toString() => name;

  static const List<Language> common = [
    Language(code:'zh',name:'中文',flag:'🇨🇳'),
    Language(code:'en',name:'English',flag:'🇺🇸'),
    Language(code:'ja',name:'日本語',flag:'🇯🇵'),
    Language(code:'ko',name:'한국어',flag:'🇰🇷'),
    Language(code:'fr',name:'Français',flag:'🇫🇷'),
    Language(code:'de',name:'Deutsch',flag:'🇩🇪'),
    Language(code:'es',name:'Español',flag:'🇪🇸'),
    Language(code:'it',name:'Italiano',flag:'🇮🇹'),
    Language(code:'pt',name:'Português',flag:'🇵🇹'),
    Language(code:'ru',name:'Русский',flag:'🇷🇺'),
    Language(code:'ar',name:'العربية',flag:'🇸🇦'),
    Language(code:'th',name:'ภาษาไทย',flag:'🇹🇭'),
    Language(code:'vi',name:'Tiếng Việt',flag:'🇻🇳'),
  ];
  static Language fromCode(String code) =>
    common.firstWhere((l) => l.code == code, orElse: () => Language(code: code, name: code));
}
