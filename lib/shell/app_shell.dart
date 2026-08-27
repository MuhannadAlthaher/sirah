import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/dashboard_page.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/profile/profile_page.dart';
import 'package:sira/score/score_page.dart';
import 'package:sira/shell/bloc/navigation_bloc.dart';
import 'package:sira/shell/bloc/navigation_event.dart';
import 'package:sira/shell/bloc/navigation_state.dart';
import 'package:sira/shell/widgets/app_bottom_nav_bar.dart';

/// The signed-in app's root shell: a bottom nav bar switching between
/// Home, Score, and Profile (which also holds Settings — see
/// [ProfilePage]).
///
/// Every bloc the shell's tabs need is provided here, scoped to the
/// shell itself rather than main.dart's true app root — onboarding
/// and login never need [DashboardBloc] or [NavigationBloc], so
/// there's no reason to keep either alive before this screen exists.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final localeKey = ValueKey(context.l10n.locale.languageCode);

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => NavigationBloc())],
      child: BlocProvider(
        key: localeKey,
        create: (_) => DashboardBloc(context.l10n),
        child: const _AppShellView(),
      ),
    );
  }
}

class _AppShellView extends StatelessWidget {
  const _AppShellView();

  // IndexedStack keeps every tab's widget tree (and scroll position)
  // alive when switching, instead of rebuilding it each time.
  static const _tabPages = [DashboardPage(), ScorePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentTab.index,
            children: _tabPages,
          ),
          bottomNavigationBar: AppBottomNavBar(
            currentTab: state.currentTab,
            onTabSelected: (index) => context.read<NavigationBloc>().add(
              NavigationTabSelected(index),
            ),
          ),
        );
      },
    );
  }
}
