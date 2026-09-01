import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Events the UI dispatches to [AppLocaleBloc].
sealed class AppLocaleEvent extends Equatable {
  const AppLocaleEvent();

  @override
  List<Object?> get props => [];
}

/// The user picked an app language from Settings. `null` means follow
/// the device language.
class AppLocaleChanged extends AppLocaleEvent {
  const AppLocaleChanged(this.locale);

  final Locale? locale;

  @override
  List<Object?> get props => [locale];
}
