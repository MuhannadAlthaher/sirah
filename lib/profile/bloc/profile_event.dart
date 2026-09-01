import 'package:equatable/equatable.dart';
import 'package:sira/profile/bloc/profile_field.dart';

/// Events the Profile UI dispatches to [ProfileBloc].
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// The user edited one text field and saved it, from that field's own
/// edit screen.
class ProfileTextFieldUpdated extends ProfileEvent {
  const ProfileTextFieldUpdated({required this.field, required this.value});

  final ProfileTextField field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}

/// The user picked a new date of birth.
class ProfileDateOfBirthUpdated extends ProfileEvent {
  const ProfileDateOfBirthUpdated(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

/// The user picked a new profile photo.
class ProfileAvatarUpdated extends ProfileEvent {
  const ProfileAvatarUpdated(this.imagePath);

  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}
