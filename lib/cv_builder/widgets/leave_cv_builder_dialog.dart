import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// What the user chose when asked whether to keep their CV Builder
/// progress before leaving.
enum LeaveCvBuilderChoice { discard, saveAndExit }

/// Opens a confirmation dialog for the close ("X") button, available
/// on every step. Returns null if the user backed out (tapped
/// Cancel or dismissed the dialog) without deciding either way.
Future<LeaveCvBuilderChoice?> showLeaveCvBuilderDialog(BuildContext context) {
  final l10n = context.l10n;

  return showDialog<LeaveCvBuilderChoice>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.cvLeaveTitle),
      content: Text(l10n.cvLeaveMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(LeaveCvBuilderChoice.discard),
          child: Text(
            l10n.cvDiscard,
            style: TextStyle(color: dialogContext.palette.danger),
          ),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(LeaveCvBuilderChoice.saveAndExit),
          child: Text(l10n.cvSaveAndExit),
        ),
      ],
    ),
  );
}
