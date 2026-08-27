import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/profile/bloc/profile_bloc.dart';
import 'package:sira/profile/personal_info_page.dart';
import 'package:sira/profile/widgets/language_toggle_row.dart';
import 'package:sira/profile/widgets/settings_row.dart';
import 'package:sira/profile/widgets/theme_mode_picker.dart';
import 'package:sira/theme/app_palette.dart';

/// The "Settings" section on the Profile screen: Personal Info,
/// Notifications, Privacy, Language, Appearance, Terms of Service,
/// About. Formerly its own bottom-nav tab; now lives here since
/// account and settings naturally belong on the same screen.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;
        final l10n = context.l10n;

        void showComingSoon(String feature) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.comingSoon(feature))));
        }

        void openPersonalInfo() {
          final bloc = context.read<ProfileBloc>();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: const PersonalInfoPage(),
              ),
            ),
          );
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: padding * 0.6),
          decoration: BoxDecoration(
            color: context.palette.surface,
            border: Border.all(color: context.palette.border),
            borderRadius: BorderRadius.circular(padding * 0.6),
          ),
          child: Column(
            children: [
              SettingsRow(
                icon: Icons.badge_outlined,
                label: l10n.personalInfo,
                onTap: openPersonalInfo,
              ),
              Divider(height: 1, color: context.palette.border),
              SettingsRow(
                icon: Icons.notifications_outlined,
                label: l10n.notifications,
                onTap: () => showComingSoon(l10n.notifications),
              ),
              Divider(height: 1, color: context.palette.border),
              SettingsRow(
                icon: Icons.lock_outline,
                label: l10n.privacy,
                onTap: () => showComingSoon(l10n.privacy),
              ),
              Divider(height: 1, color: context.palette.border),
              const LanguageToggleRow(),
              Divider(height: 1, color: context.palette.border),
              Padding(
                padding: EdgeInsets.only(top: padding * 0.6),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l10n.appearance,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              SizedBox(height: padding * 0.5),
              const ThemeModePicker(),
              SizedBox(height: padding * 0.6),
              Divider(height: 1, color: context.palette.border),
              SettingsRow(
                icon: Icons.description_outlined,
                label: l10n.termsOfService,
                onTap: () => showComingSoon(l10n.termsOfService),
              ),
              Divider(height: 1, color: context.palette.border),
              SettingsRow(
                icon: Icons.info_outline,
                label: l10n.about,
                onTap: () => showComingSoon(l10n.about),
              ),
            ],
          ),
        );
      },
    );
  }
}
