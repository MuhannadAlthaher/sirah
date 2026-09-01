import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/shell/app_shell.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/social_login_button.dart';

/// The sign-in screen shown after onboarding: a short pitch for the
/// product, one button per sign-in provider, and a guest fallback.
///
/// Every size is a fraction of the screen's own available width, so
/// it scales with the screen instead of relying on fixed pixel values.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.onGuestContinue});

  final VoidCallback onGuestContinue;

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.comingSoon(feature))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Capped the same way every other screen caps its content
            // width, so the layout stays sane on tablets/desktop/web
            // instead of stretching every element edge-to-edge.
            final width = constraints.maxWidth.clamp(0, 480).toDouble();
            final padding = width * 0.06;

            // A fixed-height Column (via Spacer) can't shrink below its
            // content's natural height, so it overflows on short
            // screens. Filling the viewport's min height instead lets
            // the column stay vertically centered on tall screens while
            // gracefully scrolling on short ones.
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: padding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - padding * 2,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.22,
                          height: width * 0.22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.palette.accentSoft,
                          ),
                          child: Icon(
                            Icons.description_outlined,
                            color: context.palette.accent,
                            size: width * 0.11,
                          ),
                        ),
                        SizedBox(height: padding),
                        Text(
                          l10n.loginTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: padding * 0.5),
                        Text(
                          l10n.loginDescription,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: context.palette.textSecondary),
                        ),
                        SizedBox(height: padding * 1.6),
                        SocialLoginButton(
                          icon: Icons.apple,
                          label: l10n.continueWithApple,
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          onPressed: () =>
                              _showComingSoon(context, l10n.continueWithApple),
                        ),
                        SizedBox(height: padding * 0.5),
                        SocialLoginButton(
                          icon: Icons.g_mobiledata,
                          label: l10n.continueWithGoogle,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          borderColor: context.palette.border,
                          onPressed: () =>
                              _showComingSoon(context, l10n.continueWithGoogle),
                        ),
                        SizedBox(height: padding * 0.5),
                        SocialLoginButton(
                          icon: Icons.email_outlined,
                          label: l10n.continueWithEmail,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          borderColor: context.palette.border,
                          onPressed: () =>
                              _showComingSoon(context, l10n.continueWithEmail),
                        ),
                        SizedBox(height: padding * 0.5),
                        SocialLoginButton(
                          icon: Icons.phone_outlined,
                          label: l10n.continueWithPhoneNumber,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          borderColor: context.palette.border,
                          onPressed: () => _openApp(context),
                        ),
                        SizedBox(height: padding * 0.8),
                        TextButton(
                          onPressed: onGuestContinue,
                          child: Text(
                            l10n.continueAsGuest,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: context.palette.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
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

  void _openApp(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AppShell()),
      (route) => false,
    );
  }
}
