import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';

/// The app shell's bottom nav tabs — one source of truth for each
/// tab's label/icons, shared by [NavigationState] and the bottom nav
/// bar widget so they can never drift out of sync.
enum AppTab {
  home(icon: Icons.home_outlined, selectedIcon: Icons.home),
  aiBuilder(icon: Icons.chat_bubble_outline, selectedIcon: Icons.chat_bubble),
  score(icon: Icons.speed_outlined, selectedIcon: Icons.speed),
  profile(icon: Icons.person_outline, selectedIcon: Icons.person);

  const AppTab({required this.icon, required this.selectedIcon});

  final IconData icon;
  final IconData selectedIcon;

  String label(AppLocalizations l10n) => switch (this) {
    AppTab.home => l10n.homeTab,
    AppTab.aiBuilder => l10n.aiBuilderTab,
    AppTab.score => l10n.scoreTab,
    AppTab.profile => l10n.profileTab,
  };
}
