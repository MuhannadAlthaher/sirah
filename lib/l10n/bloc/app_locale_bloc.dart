import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/l10n/bloc/app_locale_event.dart';
import 'package:sira/l10n/bloc/app_locale_state.dart';

/// Owns the app's language override.
///
/// Provided at the true app root in main.dart, above [MaterialApp] —
/// like theme mode, [MaterialApp] itself needs this state directly via
/// its `locale` parameter.
class AppLocaleBloc extends Bloc<AppLocaleEvent, AppLocaleState> {
  AppLocaleBloc() : super(AppLocaleState.initial()) {
    on<AppLocaleChanged>(
      (event, emit) => emit(AppLocaleState(locale: event.locale)),
    );
  }
}
