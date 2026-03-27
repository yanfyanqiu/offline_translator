// ui/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/onboarding/onboarding_bloc.dart';
import '../../core/theme.dart';
import 'onboarding_screen.dart';
import 'model_loading_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingBloc>().add(StartDiagnosis());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (ctx, state) {
          if (state is ModelsDiagnosed) {
            if (state.needsDownload) {
              Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
            } else {
              ctx.read<OnboardingBloc>().add(StartLoadingModels());
              Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) => const ModelLoadingScreen()));
            }
          } else if (state is OnboardingError) {
            Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.primaryPink], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.translate, size: 56, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text('离线翻译', style: TextStyle(color: AppTheme.textWhite, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('诊断模型状态中...', style: TextStyle(color: AppTheme.textGray, fontSize: 14)),
              const SizedBox(height: 32),
              const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 3, color: AppTheme.primaryBlue)),
            ],
          ),
        ),
      ),
    );
  }
}
