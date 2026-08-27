import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A full-screen date picker for editing Date of Birth — opened by
/// tapping its row on [PersonalInfoPage]. Calls [onSave] with
/// whatever date is currently selected when the user taps Save, then
/// pops.
///
/// Tracks the selected date in a [ValueNotifier] created once in the
/// constructor (not inside [build]) so it survives this page
/// rebuilding, without needing a [StatefulWidget].
class EditDateOfBirthPage extends StatelessWidget {
  EditDateOfBirthPage({super.key, DateTime? initialDate, required this.onSave})
    : selected = ValueNotifier(
        initialDate ?? DateTime(DateTime.now().year - 25),
      );

  final ValueNotifier<DateTime> selected;
  final ValueChanged<DateTime> onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      appBar: AppBar(
        backgroundColor: context.palette.screenBackground,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
        title: Text(l10n.dateOfBirth),
        actions: [
          TextButton(
            onPressed: () {
              onSave(selected.value);
              Navigator.of(context).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
      body: SafeArea(
        child: CalendarDatePicker(
          initialDate: selected.value,
          firstDate: DateTime(now.year - 100),
          lastDate: now,
          onDateChanged: (date) => selected.value = date,
        ),
      ),
    );
  }
}
