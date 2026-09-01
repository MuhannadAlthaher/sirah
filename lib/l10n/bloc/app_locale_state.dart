import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// The app's current locale override. `null` means follow the device
/// language, with the app's own fallback logic deciding between Arabic
/// and English.
class AppLocaleState extends Equatable {
  const AppLocaleState({required this.locale});

  factory AppLocaleState.initial() => const AppLocaleState(locale: null);

  final Locale? locale;

  @override
  List<Object?> get props => [locale];
}
