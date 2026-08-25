import 'package:flutter/material.dart';
import 'package:sira/dashboard/dashboard_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final padding = width * 0.06;

            // A fixed-height Column (via Spacer) can't shrink below its
            // content's natural height, so it overflows on short
            // screens. Filling the viewport's min height instead lets
            // the column stay vertically centered on tall screens while
            // gracefully scrolling on short ones.
            return SingleChildScrollView(
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.accentSoft,
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: AppPalette.accent,
                        size: width * 0.11,
                      ),
                    ),
                    SizedBox(height: padding),
                    Text(
                      'Build a resume that gets you hired',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: padding * 0.5),
                    Text(
                      'Sign in to save your CV, access it on any device, and '
                      'unlock AI rewriting, ATS scoring, and premium '
                      'templates.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                    SizedBox(height: padding * 1.6),
                    SocialLoginButton(
                      icon: Icons.apple,
                      label: 'Continue with Apple',
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      onPressed: () {},
                    ),
                    SizedBox(height: padding * 0.5),
                    SocialLoginButton(
                      icon: Icons.g_mobiledata,
                      label: 'Continue with Google',
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      borderColor: AppPalette.border,
                      onPressed: () {},
                    ),
                    SizedBox(height: padding * 0.5),
                    SocialLoginButton(
                      icon: Icons.email_outlined,
                      label: 'Continue with Email',
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      borderColor: AppPalette.border,
                      onPressed: () {},
                    ),
                    SizedBox(height: padding * 0.5),
                    SocialLoginButton(
                      icon: Icons.phone_outlined,
                      label: 'Continue with Phone Number',
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      borderColor: AppPalette.border,
                      onPressed: () => _openDashboard(context),
                    ),
                    SizedBox(height: padding * 0.8),
                    TextButton(
                      onPressed: onGuestContinue,
                      child: Text(
                        'Continue as Guest',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openDashboard(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DashboardPage()));
  }
}
