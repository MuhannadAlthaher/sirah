import 'package:flutter/material.dart';
import 'package:sira/cv_builder/data/countries.dart';
import 'package:sira/cv_builder/widgets/country_picker_page.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A tappable field styled like a [TextFormField] that opens
/// [CountryPickerPage] and reports back whatever the user picks
/// there. [value] is the currently selected country, or empty.
class CountrySelectorField extends StatelessWidget {
  const CountrySelectorField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      onTap: () async {
        final picked = await Navigator.of(
          context,
        ).push<String>(MaterialPageRoute(builder: (_) => CountryPickerPage()));
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.chevron_right,
            color: context.palette.textMuted,
          ),
        ),
        child: Text(
          value.isEmpty
              ? l10n.cvSelectCountry
              : countryDisplayName(value, l10n),
          style: TextStyle(
            color: value.isEmpty
                ? Theme.of(context).hintColor
                : context.palette.textPrimary,
          ),
        ),
      ),
    );
  }
}
