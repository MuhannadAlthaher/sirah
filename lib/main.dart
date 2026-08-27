import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show FlutterQuillLocalizations;
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/l10n/bloc/app_locale_bloc.dart';
import 'package:sira/l10n/bloc/app_locale_state.dart';
import 'package:sira/onboarding/onboarding.dart';
import 'package:sira/theme/app_theme.dart';
import 'package:sira/theme/bloc/theme_bloc.dart';
import 'package:sira/theme/bloc/theme_state.dart';

void main() {
  runApp(const MainApp());
}

/// The app's root. [ThemeBloc] is provided here, above [MaterialApp],
/// because [MaterialApp] itself needs it directly (`themeMode`).
/// [AppLocaleBloc] lives at the same scope for the same reason
/// (`locale`). [AppShell] (and the blocs its signed-in tabs need, like
/// [DashboardBloc]) is only reached — and only provided — once the
/// user gets past login, since nothing before that needs it.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static Locale _resolveDeviceLocale(List<Locale>? deviceLocales) {
    final deviceLocale = deviceLocales?.first;
    return deviceLocale?.languageCode == 'ar'
        ? const Locale('ar')
        : const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => AppLocaleBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<AppLocaleBloc, AppLocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeState.mode,
                locale: localeState.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  FlutterQuillLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                localeListResolutionCallback:
                    (deviceLocales, supportedLocales) =>
                        _resolveDeviceLocale(deviceLocales),
                home: const Onboarding(),
              );
            },
          );
        },
      ),
    );
  }
}
