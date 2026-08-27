import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sira/onboarding/onboarding.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/theme/bloc/theme_bloc.dart';

/// Shown once at app launch while the Lottie splash animation plays,
/// then hands off to [Onboarding]. Picks the light/dark animation
/// asset the same way the rest of the app resolves its palette: the
/// user's explicit [ThemeBloc] choice when set, otherwise the
/// device's own brightness.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _goToOnboarding() {
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const Onboarding()));
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeBloc>().state.mode;
    final isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    final palette = isDark ? AppPalette.dark : AppPalette.light;
    final asset = isDark
        ? 'assets/animations/sira_splash_dark.json'
        : 'assets/animations/sira_splash_light.json';

    return Scaffold(
      backgroundColor: palette.screenBackground,
      body: Center(
        child: Lottie.asset(
          asset,
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, _goToOnboarding);
          },
        ),
      ),
    );
  }
}
