// models/translation_result.dart
import 'package:equatable/equatable.dart';

class TranslationResult extends Equatable {
  final String id;
  final String sourceText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final DateTime timestamp;
  final Duration? asrDuration;
  final Duration? mtDuration;
  const TranslationResult({
    required this.id, required this.sourceText, required this.translatedText,
    required this.sourceLang, required this.targetLang, required this.timestamp,
    this.asrDuration, this.mtDuration,
  });
  @override List<Object?> get props => [id,sourceText,translatedText,sourceLang,targetLang,timestamp,asrDuration,mtDuration];
}

enum TranslationState { idle, recording, recognizing, translating, synthesizing, playing, done, error }
enum ModelState { notLoaded, downloading, loading, loaded, error }
