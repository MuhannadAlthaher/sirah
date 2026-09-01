import 'package:equatable/equatable.dart';
import 'package:sira/data/demo_data.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/profile/bloc/profile_field.dart';

/// The user's editable profile fields.
class ProfileState extends Equatable {
  const ProfileState({
    required this.name,
    required this.position,
    required this.email,
    required this.phone,
    required this.location,
    this.dateOfBirth,
    this.avatarPath,
  });

  /// Demo data for now — swap for the real profile once auth exists.
  factory ProfileState.initial(AppLocalizations l10n) {
    final user = demoUserFor(l10n);
    return ProfileState(
      name: user.name,
      position: user.position,
      email: 'alex.morgan@example.com',
      phone: '+1 555 0100',
      location: 'San Francisco, CA',
    );
  }

  final String name;
  final String position;
  final String email;
  final String phone;
  final String location;

  /// Null until the user sets it from the Date of Birth edit screen.
  final DateTime? dateOfBirth;

  /// Local file path of the user's chosen profile photo, or null to
  /// show the initials placeholder.
  final String? avatarPath;

  String valueFor(ProfileTextField field) => switch (field) {
    ProfileTextField.name => name,
    ProfileTextField.position => position,
    ProfileTextField.email => email,
    ProfileTextField.phone => phone,
    ProfileTextField.location => location,
  };

  ProfileState withTextField(ProfileTextField field, String value) =>
      switch (field) {
        ProfileTextField.name => _copyWith(name: value),
        ProfileTextField.position => _copyWith(position: value),
        ProfileTextField.email => _copyWith(email: value),
        ProfileTextField.phone => _copyWith(phone: value),
        ProfileTextField.location => _copyWith(location: value),
      };

  ProfileState withDateOfBirth(DateTime date) => _copyWith(dateOfBirth: date);

  ProfileState withAvatarPath(String path) => _copyWith(avatarPath: path);

  @override
  List<Object?> get props => [
    name,
    position,
    email,
    phone,
    location,
    dateOfBirth,
    avatarPath,
  ];

  ProfileState _copyWith({
    String? name,
    String? position,
    String? email,
    String? phone,
    String? location,
    DateTime? dateOfBirth,
    String? avatarPath,
  }) {
    return ProfileState(
      name: name ?? this.name,
      position: position ?? this.position,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
