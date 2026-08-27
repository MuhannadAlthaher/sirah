import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/onboarding.dart';
import 'package:sira/profile/bloc/profile_bloc.dart';
import 'package:sira/profile/bloc/profile_event.dart';
import 'package:sira/profile/bloc/profile_state.dart';
import 'package:sira/profile/widgets/avatar_picker.dart';
import 'package:sira/profile/widgets/settings_section.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/position_badge.dart';

/// The "Profile" tab: two sections — the user's own info (photo,
/// name, position, editable details), and Settings (formerly its own
/// bottom-nav tab; account and settings naturally belong on the same
/// screen).
///
/// Owns a [ProfileBloc], scoped to this tab and kept alive by the
/// shell's `IndexedStack` (same pattern as `OnboardingBloc`). The
/// bloc is seeded once from demo data in whichever language is
/// active on first mount and is *not* re-keyed on locale change like
/// `DashboardBloc` is — its fields are user-editable, so recreating
/// it on every language switch would silently discard edits.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(context.l10n),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(0, 480).toDouble();
            final padding = width * 0.05;

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Profile section ---
                      Text(
                        l10n.profileTab,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: padding),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          return Center(
                            child: Column(
                              children: [
                                AvatarPicker(
                                  name: state.name,
                                  size: width * 0.26,
                                  imagePath: state.avatarPath,
                                  onPicked: (path) => context
                                      .read<ProfileBloc>()
                                      .add(ProfileAvatarUpdated(path)),
                                ),
                                SizedBox(height: padding * 0.6),
                                Text(
                                  state.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: padding * 0.4),
                                PositionBadge(
                                  position: state.position,
                                  width: width,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // --- Settings section ---
                      SizedBox(height: padding * 1.4),
                      Text(
                        l10n.settingsTitle,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: padding * 0.5),
                      const SettingsSection(),

                      SizedBox(height: padding * 1.4),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _logOut(context),
                          icon: Icon(
                            Icons.logout,
                            color: context.palette.danger,
                          ),
                          label: Text(l10n.logOut),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.palette.danger,
                            side: BorderSide(color: context.palette.danger),
                            padding: EdgeInsets.symmetric(
                              vertical: padding * 0.6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                padding * 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _logOut(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Onboarding()),
      (route) => false,
    );
  }
}
