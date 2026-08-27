import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/profile/bloc/profile_bloc.dart';
import 'package:sira/profile/bloc/profile_event.dart';
import 'package:sira/profile/bloc/profile_field.dart';
import 'package:sira/profile/bloc/profile_state.dart';
import 'package:sira/profile/edit_date_of_birth_page.dart';
import 'package:sira/profile/edit_text_field_page.dart';
import 'package:sira/profile/widgets/profile_detail_row.dart';
import 'package:sira/theme/app_palette.dart';

/// The "Personal Info" screen: Name, Position, Email, Phone,
/// Location, and Date of Birth, each tappable to open its own edit
/// screen. Opened from the "Personal Info" row in Settings, reusing
/// the [ProfileBloc] already provided by the Profile tab (reattached
/// via `BlocProvider.value` when this page is pushed, since pushing a
/// route steps outside that provider's subtree).
class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      appBar: AppBar(
        backgroundColor: context.palette.screenBackground,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
        title: Text(l10n.personalInfo),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(0, 480).toDouble();
            final padding = width * 0.05;

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: padding * 0.6),
                    decoration: BoxDecoration(
                      color: context.palette.surface,
                      border: Border.all(color: context.palette.border),
                      borderRadius: BorderRadius.circular(padding * 0.6),
                    ),
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        final divider = Divider(
                          height: 1,
                          color: context.palette.border,
                        );
                        final dob = state.dateOfBirth;

                        return Column(
                          children: [
                            ProfileDetailRow(
                              icon: Icons.person_outline,
                              label: l10n.profileName,
                              value: state.name,
                              onTap: () => _editTextField(
                                context,
                                field: ProfileTextField.name,
                                label: l10n.profileName,
                                value: state.name,
                              ),
                            ),
                            divider,
                            ProfileDetailRow(
                              icon: Icons.work_outline,
                              label: l10n.profilePosition,
                              value: state.position,
                              onTap: () => _editTextField(
                                context,
                                field: ProfileTextField.position,
                                label: l10n.profilePosition,
                                value: state.position,
                              ),
                            ),
                            divider,
                            ProfileDetailRow(
                              icon: Icons.email_outlined,
                              label: l10n.profileEmail,
                              value: state.email,
                              onTap: () => _editTextField(
                                context,
                                field: ProfileTextField.email,
                                label: l10n.profileEmail,
                                value: state.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            divider,
                            ProfileDetailRow(
                              icon: Icons.phone_outlined,
                              label: l10n.profilePhone,
                              value: state.phone,
                              onTap: () => _editTextField(
                                context,
                                field: ProfileTextField.phone,
                                label: l10n.profilePhone,
                                value: state.phone,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            divider,
                            ProfileDetailRow(
                              icon: Icons.location_on_outlined,
                              label: l10n.profileLocation,
                              value: state.location,
                              onTap: () => _editTextField(
                                context,
                                field: ProfileTextField.location,
                                label: l10n.profileLocation,
                                value: state.location,
                              ),
                            ),
                            divider,
                            ProfileDetailRow(
                              icon: Icons.cake_outlined,
                              label: l10n.dateOfBirth,
                              value: dob == null
                                  ? l10n.notSet
                                  : l10n.formatDate(dob),
                              onTap: () => _editDateOfBirth(context, dob),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _editTextField(
    BuildContext context, {
    required ProfileTextField field,
    required String label,
    required String value,
    TextInputType? keyboardType,
  }) {
    final bloc = context.read<ProfileBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditTextFieldPage(
          label: label,
          initialValue: value,
          keyboardType: keyboardType,
          onSave: (newValue) =>
              bloc.add(ProfileTextFieldUpdated(field: field, value: newValue)),
        ),
      ),
    );
  }

  void _editDateOfBirth(BuildContext context, DateTime? current) {
    final bloc = context.read<ProfileBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditDateOfBirthPage(
          initialDate: current,
          onSave: (date) => bloc.add(ProfileDateOfBirthUpdated(date)),
        ),
      ),
    );
  }
}
