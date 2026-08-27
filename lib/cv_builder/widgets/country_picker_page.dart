import 'package:flutter/material.dart';
import 'package:sira/cv_builder/data/countries.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A searchable full-screen picker over [kCountries]. Pops with the
/// chosen country name, or null if the user backs out.
///
/// The live search query lives in a [ValueNotifier] created once in
/// the constructor (not inside [build]), paired with
/// [ValueListenableBuilder] — reactive filtering without needing a
/// [StatefulWidget].
class CountryPickerPage extends StatelessWidget {
  CountryPickerPage({super.key});

  final ValueNotifier<String> _query = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      appBar: AppBar(
        backgroundColor: context.palette.screenBackground,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
        title: Text(l10n.cvSelectCountry),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth * 0.05;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) => _query.value = value,
                    decoration: InputDecoration(
                      hintText: l10n.cvSearchCountry,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: _query,
                    builder: (context, query, _) {
                      final matches = kCountries
                          .where(
                            (country) => country.toLowerCase().contains(
                              query.trim().toLowerCase(),
                            ),
                          )
                          .toList();

                      if (matches.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.cvNoCountryFound,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: context.palette.textSecondary,
                                ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: matches.length,
                        itemBuilder: (context, index) {
                          final country = matches[index];
                          return ListTile(
                            title: Text(country),
                            onTap: () => Navigator.of(context).pop(country),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
