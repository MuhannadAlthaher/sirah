import 'package:equatable/equatable.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/l10n/app_localizations.dart';

/// The signed-in user, shown across the dashboard/profile/score
/// screens. Demo data for now — swap for the real profile once auth
/// is wired up.
class DemoUser extends Equatable {
  const DemoUser({required this.name, required this.position});

  final String name;
  final String position;

  @override
  List<Object?> get props => [name, position];
}

/// One CV entry shown on the dashboard — always backed by a real
/// [builderState] produced by the CV Builder (there's no seeded/dummy
/// data anymore; "My CVs" starts empty until the user actually
/// creates one). Persisted on-device via `CvStorage` so it survives
/// an app restart.
class DemoCv extends Equatable {
  const DemoCv({
    required this.id,
    required this.name,
    required this.subtitle,
    this.builderState,
  });

  final String id;
  final String name;
  final String subtitle;
  final CvBuilderState? builderState;

  @override
  List<Object?> get props => [id, name, subtitle, builderState];

  DemoCv copyWith({
    String? name,
    String? subtitle,
    CvBuilderState? builderState,
  }) {
    return DemoCv(
      id: id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      builderState: builderState ?? this.builderState,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subtitle': subtitle,
    'builderState': builderState?.toJson(),
  };

  factory DemoCv.fromJson(Map<String, dynamic> json) {
    return DemoCv(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      builderState: json['builderState'] == null
          ? null
          : CvBuilderState.fromJson(
              json['builderState'] as Map<String, dynamic>,
            ),
    );
  }
}

DemoUser demoUserFor(AppLocalizations l10n) =>
    DemoUser(name: l10n.demoUserName, position: l10n.demoUserPosition);

/// The user's average ATS match score across their CVs, out of 100.
/// Demo data for now — swap for the real computed score once ATS
/// scoring exists.
const demoAtsScore = 87;
