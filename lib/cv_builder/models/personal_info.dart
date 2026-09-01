import 'package:equatable/equatable.dart';

/// The CV Builder's Step 1 answers.
class PersonalInfo extends Equatable {
  const PersonalInfo({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.city = '',
    this.country = '',
    this.dateOfBirth,
    this.nationality = '',
    this.hasDrivingLicense,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String country;

  /// Optional.
  final DateTime? dateOfBirth;

  /// Optional.
  final String nationality;

  /// Optional — null means not answered yet.
  final bool? hasDrivingLicense;

  bool get isComplete =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      country.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    city,
    country,
    dateOfBirth,
    nationality,
    hasDrivingLicense,
  ];

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'city': city,
    'country': country,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'nationality': nationality,
    'hasDrivingLicense': hasDrivingLicense,
  };

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      nationality: json['nationality'] as String? ?? '',
      hasDrivingLicense: json['hasDrivingLicense'] as bool?,
    );
  }

  PersonalInfo copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? city,
    String? country,
    DateTime? dateOfBirth,
    String? nationality,
    bool? hasDrivingLicense,
  }) {
    return PersonalInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      country: country ?? this.country,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      hasDrivingLicense: hasDrivingLicense ?? this.hasDrivingLicense,
    );
  }
}
