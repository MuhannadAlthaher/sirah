import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/shell/app_tab.dart';
import 'package:sira/theme/app_palette.dart';

/// The app's bottom navigation bar. Purely presentational: [currentTab]
/// and [onTabSelected] are supplied by the caller (typically wired to
/// [NavigationBloc]) rather than decided here.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final AppTab currentTab;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BottomNavigationBar(
      currentIndex: currentTab.index,
      onTap: onTabSelected,
      type: BottomNavigationBarType.fixed,
      backgroundColor: context.palette.surface,
      selectedItemColor: context.palette.accent,
      unselectedItemColor: context.palette.textMuted,
      items: [
        for (final tab in AppTab.values)
          BottomNavigationBarItem(
            icon: Icon(tab == currentTab ? tab.selectedIcon : tab.icon),
            label: tab.label(l10n),
          ),
      ],
    );
  }
}
