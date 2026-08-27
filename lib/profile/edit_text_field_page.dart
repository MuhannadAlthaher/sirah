import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A full-screen editor for one text field (Name, Position, Email,
/// Phone, or Location) — opened by tapping that field's row on
/// [PersonalInfoPage]. Calls [onSave] with the trimmed value when the
/// user taps Save, then pops.
///
/// Reads the field's current text from a [GlobalKey] on the
/// [TextFormField] rather than a [TextEditingController]: the key
/// reaches the live [FormFieldState] at Save time regardless of how
/// many times this page has rebuilt, with no controller lifecycle to
/// manage.
class EditTextFieldPage extends StatelessWidget {
  EditTextFieldPage({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onSave,
    this.keyboardType,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onSave;
  final TextInputType? keyboardType;

  final _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      appBar: AppBar(
        backgroundColor: context.palette.screenBackground,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
        title: Text('${l10n.edit} $label'),
        actions: [
          TextButton(
            onPressed: () {
              onSave((_fieldKey.currentState!.value ?? '').trim());
              Navigator.of(context).pop();
            },
            child: Text(l10n.save),
          ),
        ],
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
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: TextFormField(
                    key: _fieldKey,
                    initialValue: initialValue,
                    autofocus: true,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(labelText: label),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
