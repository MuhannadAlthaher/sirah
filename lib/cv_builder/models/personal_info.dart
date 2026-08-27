/// The CV Builder's Step 1 answers.
class PersonalInfo {
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
