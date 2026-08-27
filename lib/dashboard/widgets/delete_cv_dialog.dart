import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A confirmation dialog for deleting a CV from "My CVs" — deleting is
/// unrecoverable (there's no trash/undo yet), so it's never triggered
/// straight from the "⋮" menu's Delete tap.
///
/// Returns `true` only if the user tapped Delete; `false` or `null`
/// (Cancel, or dismissing the dialog) means keep the CV.
Future<bool> showDeleteCvDialog(BuildContext context, String cvName) async {
  final l10n = context.l10n;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.cvDeleteTitle),
      content: Text(l10n.cvDeleteMessage(cvName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            l10n.delete,
            style: TextStyle(color: dialogContext.palette.danger),
          ),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
