import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// A tappable field styled like a [TextFormField] that opens
/// [showMonthYearPicker] and reports back whatever the user picks.
/// Shows "January 2024" once set (via [l10n.formatMonthYear]), or
/// [placeholder] while unset. [label] (e.g. "Start Date") isn't shown
/// again here — the caller already precedes this with its own
/// `FormFieldLabel` — but is still announced for screen readers.
class MonthYearField extends StatelessWidget {
  const MonthYearField({
    super.key,
    required this.label,
    required this.month,
    required this.year,
    required this.onSelected,
    this.enabled = true,
    this.placeholder,
  });

  final String label;
  final int? month;
  final int? year;
  final ValueChanged<(int month, int year)> onSelected;
  final bool enabled;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasValue = month != null && year != null;

    return Semantics(
      label: label,
      button: true,
      enabled: enabled,
      child: InkWell(
        onTap: !enabled
            ? null
            : () => showMonthYearPicker(
                context,
                initialMonth: month,
                initialYear: year,
                onSelected: (m, y) => onSelected((m, y)),
              ),
        child: InputDecorator(
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              color: context.palette.textMuted,
            ),
          ),
          child: Text(
            hasValue
                ? l10n.formatMonthYear(month!, year!)
                : (placeholder ?? l10n.cvSelectDate),
            style: TextStyle(
              color: hasValue
                  ? context.palette.textPrimary
                  : Theme.of(context).hintColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens a bottom sheet with Month/Year dropdowns, calling
/// [onSelected] with the chosen pair if the user saves (dismissing
/// the sheet does nothing).
///
/// The selection lives in plain local variables in this function,
/// not a field — [StatefulBuilder] gives the sheet's own local
/// rebuild-on-change without needing a dedicated [StatefulWidget]
/// class, and (like `showEditProfileFieldDialog`'s pattern elsewhere
/// in this app) those variables survive the sheet's internal
/// rebuilds because this enclosing function only runs once.
Future<void> showMonthYearPicker(
  BuildContext context, {
  required int? initialMonth,
  required int? initialYear,
  required void Function(int month, int year) onSelected,
}) async {
  final l10n = context.l10n;
  final now = DateTime.now();
  var month = initialMonth ?? now.month;
  var year = initialYear ?? now.year;

  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final padding = MediaQuery.sizeOf(sheetContext).width * 0.05;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          padding,
          padding,
          padding,
          padding + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cvSelectMonthYear,
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: padding),
                // Stacked, not side-by-side: two dropdowns sharing a
                // row leaves too little width for a long month name
                // (e.g. "September") plus its label and arrow once
                // the app's input theme's own padding is subtracted —
                // stacking sidesteps that fight for width entirely.
                DropdownButtonFormField<int>(
                  value: month,
                  decoration: InputDecoration(labelText: l10n.cvMonth),
                  items: [
                    for (var m = 1; m <= 12; m++)
                      DropdownMenuItem(
                        value: m,
                        child: Text(l10n.monthNames[m - 1]),
                      ),
                  ],
                  onChanged: (value) => setSheetState(() => month = value!),
                ),
                SizedBox(height: padding * 0.6),
                DropdownButtonFormField<int>(
                  value: year,
                  decoration: InputDecoration(labelText: l10n.cvYear),
                  items: [
                    for (var y = now.year; y >= now.year - 60; y--)
                      DropdownMenuItem(value: y, child: Text('$y')),
                  ],
                  onChanged: (value) => setSheetState(() => year = value!),
                ),
                SizedBox(height: padding),
                PrimaryCtaButton(
                  label: l10n.save,
                  icon: Icons.check,
                  onPressed: () => Navigator.of(sheetContext).pop(true),
                ),
              ],
            );
          },
        ),
      );
    },
  );

  if (confirmed ?? false) onSelected(month, year);
}
