import 'package:flutter/widgets.dart';

/// Events the UI dispatches to [AppLocaleBloc].
sealed class AppLocaleEvent {
  const AppLocaleEvent();
}

/// The user picked an app language from Settings. `null` means follow
/// the device language.
class AppLocaleChanged extends AppLocaleEvent {
  const AppLocaleChanged(this.locale);

  final Locale? locale;
}
