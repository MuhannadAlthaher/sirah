import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/models/personal_info.dart';
import 'package:sira/cv_builder/widgets/country_selector_field.dart';
import 'package:sira/cv_builder/widgets/driving_license_toggle.dart';
import 'package:sira/cv_builder/widgets/form_field_label.dart';
import 'package:sira/cv_builder/widgets/step_bottom_bar.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/widgets/secondary_outline_button.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// Step 1: the user's basic personal details.
///
/// Every field writes straight to [CvBuilderBloc] on change (not
/// deferred to a "Continue" press), so [CvBuilderState.personalInfo]
/// is always current — that's what lets the user leave and return to
/// this step without losing anything, and it means "Continue" only
/// needs to validate, not gather values.
///
/// A [StatefulWidget] only because [Form] needs a [GlobalKey] that
/// stays the same instance across this widget's whole lifetime, and
/// "whether Continue has been pressed yet" (so the Country field only
/// shows its error after a real attempt, matching how the text
/// fields' own validators behave) — neither is naturally available
/// without local state that survives rebuilds.
class PersonalInfoStep extends StatefulWidget {
  const PersonalInfoStep({super.key});

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  void _update(PersonalInfo Function(PersonalInfo current) apply) {
    final bloc = context.read<CvBuilderBloc>();
    bloc.add(CvBuilderPersonalInfoChanged(apply(bloc.state.personalInfo)));
  }

  void _continue() {
    setState(() => _submitted = true);
    final bloc = context.read<CvBuilderBloc>();
    final formValid = _formKey.currentState!.validate();
    final countryValid = bloc.state.personalInfo.country.trim().isNotEmpty;
    if (formValid && countryValid) {
      bloc.add(const CvBuilderNextStepRequested());
    }
  }

  // Skip bypasses the required-field validation entirely — the Hub
  // (not this step) is the source of truth for what's still needed,
  // and it already shows Personal Info as incomplete until the user
  // comes back and fills it in.
  void _skip() =>
      context.read<CvBuilderBloc>().add(const CvBuilderNextStepRequested());

  String? _required(String? value) {
    final l10n = context.l10n;
    return (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // A one-time snapshot: TextFormField only reads `initialValue`
    // when it's first created, so re-reading this on later rebuilds
    // wouldn't change what's displayed anyway (see onChanged above
    // for why edits aren't lost regardless).
    final initial = context.read<CvBuilderBloc>().state.personalInfo;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;
        final gap = padding * 0.9;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: context.palette.surface,
                    border: Border.all(color: context.palette.border),
                    borderRadius: BorderRadius.circular(padding * 0.6),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormFieldLabel(label: l10n.cvFirstName),
                        SizedBox(height: padding * 0.3),
                        TextFormField(
                          initialValue: initial.firstName,
                          textCapitalization: TextCapitalization.words,
                          validator: _required,
                          onChanged: (v) =>
                              _update((p) => p.copyWith(firstName: v)),
                        ),
                        SizedBox(height: gap),
                        FormFieldLabel(label: l10n.cvLastName),
                        SizedBox(height: padding * 0.3),
                        TextFormField(
                          initialValue: initial.lastName,
                          textCapitalization: TextCapitalization.words,
                          validator: _required,
                          onChanged: (v) =>
                              _update((p) => p.copyWith(lastName: v)),
                        ),
                        SizedBox(height: gap),
                        FormFieldLabel(label: l10n.cvEmail),
                        SizedBox(height: padding * 0.3),
                        TextFormField(
                          initialValue: initial.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            final requiredError = _required(v);
                            if (requiredError != null) return requiredError;
                            final email = v!.trim();
                            final valid =
                                email.contains('@') &&
                                email.indexOf('@') < email.lastIndexOf('.');
                            return valid ? null : l10n.invalidEmail;
                          },
                          onChanged: (v) =>
                              _update((p) => p.copyWith(email: v)),
                        ),
                        SizedBox(height: gap),
                        FormFieldLabel(label: l10n.cvPhone),
                        SizedBox(height: padding * 0.3),
                        TextFormField(
                          initialValue: initial.phone,
                          keyboardType: TextInputType.phone,
                          validator: _required,
                          onChanged: (v) =>
                              _update((p) => p.copyWith(phone: v)),
                        ),
                        SizedBox(height: gap),
                        FormFieldLabel(label: l10n.cvCity),
                        SizedBox(height: padding * 0.3),
                        TextFormField(
                          initialValue: initial.city,
                          textCapitalization: TextCapitalization.words,
                          validator: _required,
                          onChanged: (v) => _update((p) => p.copyWith(city: v)),
                        ),
                        SizedBox(height: gap),
                        FormFieldLabel(label: l10n.cvCountry),
                        SizedBox(height: padding * 0.3),
                        BlocSelector<CvBuilderBloc, CvBuilderState, String>(
                          selector: (state) => state.personalInfo.country,
                          builder: (context, country) {
                            final showError =
                                _submitted && country.trim().isEmpty;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CountrySelectorField(
                                  value: country,
                                  onChanged: (value) => _update(
                                    (p) => p.copyWith(country: value),
                                  ),
                                ),
                                if (showError) ...[
                                  SizedBox(height: padding * 0.2),
                                  Text(
                                    l10n.fieldRequired,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.palette.danger,
                                        ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                        SizedBox(height: gap),
                        FormFieldLabel(
                          label: l10n.dateOfBirth,
                          isOptional: true,
                        ),
                        SizedBox(height: padding * 0.3),
                        BlocSelector<CvBuilderBloc, CvBuilderState, DateTime?>(
                          selector: (state) => state.personalInfo.dateOfBirth,
                          builder: (context, dateOfBirth) => _DateOfBirthField(
                            value: dateOfBirth,
                            onChanged: (date) =>
                                _update((p) => p.copyWith(dateOfBirth: date)),
                          ),
                        ),
                        SizedBox(height: gap),
                        FormFieldLabel(
                          label: l10n.cvNationality,
                          isOptional: true,
                        ),
                        SizedBox(height: padding * 0.3),
                        TextFormField(
                          initialValue: initial.nationality,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (v) =>
                              _update((p) => p.copyWith(nationality: v)),
                        ),
                        SizedBox(height: gap),
                        FormFieldLabel(
                          label: l10n.cvDrivingLicense,
                          isOptional: true,
                        ),
                        SizedBox(height: padding * 0.3),
                        BlocSelector<CvBuilderBloc, CvBuilderState, bool?>(
                          selector: (state) =>
                              state.personalInfo.hasDrivingLicense,
                          builder: (context, hasDrivingLicense) =>
                              DrivingLicenseToggle(
                                value: hasDrivingLicense,
                                onChanged: (value) => _update(
                                  (p) => p.copyWith(hasDrivingLicense: value),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            StepBottomBar(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SecondaryOutlineButton(
                        label: l10n.skip,
                        onPressed: _skip,
                      ),
                    ),
                    SizedBox(width: padding * 0.6),
                    Expanded(
                      child: PrimaryCtaButton(
                        label: l10n.continueLabel,
                        onPressed: _continue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// The Date of Birth field: tapping it opens the platform's built-in
/// date picker.
class _DateOfBirthField extends StatelessWidget {
  const _DateOfBirthField({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime(now.year - 25),
          firstDate: DateTime(now.year - 100),
          lastDate: now,
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.calendar_today_outlined,
            color: context.palette.textMuted,
          ),
        ),
        child: Text(
          value == null ? l10n.cvSelectDate : l10n.formatDate(value!),
          style: TextStyle(
            color: value == null
                ? Theme.of(context).hintColor
                : context.palette.textPrimary,
          ),
        ),
      ),
    );
  }
}
