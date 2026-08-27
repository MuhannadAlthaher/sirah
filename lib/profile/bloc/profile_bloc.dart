import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/profile/bloc/profile_event.dart';
import 'package:sira/profile/bloc/profile_state.dart';

/// Owns the user's editable profile fields, so [ProfilePage] and
/// [PersonalInfoPage] stay pure presentation layers with no state of
/// their own.
///
/// Scoped to the Profile tab — provided by [ProfilePage] itself, kept
/// alive by the shell's `IndexedStack` (which never disposes tabs), so
/// edits survive switching tabs, same pattern as `OnboardingBloc`.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(AppLocalizations l10n) : super(ProfileState.initial(l10n)) {
    on<ProfileTextFieldUpdated>(
      (event, emit) => emit(state.withTextField(event.field, event.value)),
    );
    on<ProfileDateOfBirthUpdated>(
      (event, emit) => emit(state.withDateOfBirth(event.date)),
    );
    on<ProfileAvatarUpdated>(
      (event, emit) => emit(state.withAvatarPath(event.imagePath)),
    );
  }
}
