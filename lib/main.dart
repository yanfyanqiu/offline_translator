// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'services/translation_pipeline.dart';
import 'services/model_loader.dart';
import 'blocs/onboarding/onboarding_bloc.dart';
import 'blocs/translation/translation_bloc.dart';
import 'blocs/settings/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final pipeline = TranslationPipeline();
  final modelLoader = ModelLoaderService(pipeline);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => OnboardingBloc(modelLoader)),
      BlocProvider(create: (_) => TranslationBloc(pipeline)),
      BlocProvider(create: (_) => SettingsBloc()),
    ],
    child: const OfflineTranslatorApp(),
  ));
}
