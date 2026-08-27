import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// Dummy, in-memory stand-in for a real payment/subscription check.
/// There's no backend or payment processor wired up yet, so this only
/// ever flips via [showWatermarkPaywallSheet]'s "Simulate Successful
/// Payment" button, and resets every app launch.
class WatermarkGate {
  WatermarkGate._();

  static final ValueNotifier<bool> isPremium = ValueNotifier<bool>(false);
}

/// A dummy checkout sheet: explains what removing the watermark buys,
/// then lets the user simulate a successful payment to flip
/// [WatermarkGate.isPremium] for the rest of this app session — for
/// testing the flow before real payments exist.
Future<void> showWatermarkPaywallSheet(BuildContext context) {
  final l10n = context.l10n;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline, color: context.palette.accent, size: 32),
              const SizedBox(height: 12),
              Text(
                l10n.cvPaywallTitle,
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.cvPaywallDescription,
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                  color: context.palette.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.cvPaywallPrice,
                style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.palette.accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.cvPaywallDummyNotice,
                style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                  color: context.palette.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              PrimaryCtaButton(
                label: l10n.cvPaywallSimulatePayment,
                icon: Icons.check_circle_outline,
                onPressed: () {
                  WatermarkGate.isPremium.value = true;
                  Navigator.of(sheetContext).pop();
                },
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(l10n.cvPaywallCancel),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
