import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/ai_builder/ai_builder_page.dart';
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
/// Home, AI Builder, Score, and Profile (which also holds Settings —
/// see [ProfilePage]).
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
  static const _tabPages = [
    DashboardPage(),
    AiBuilderPage(),
    ScorePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: _TabFade(
            index: state.currentTab.index,
            child: IndexedStack(
              index: state.currentTab.index,
              children: _tabPages,
            ),
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

/// Fades [child] in on every [index] change — without ever rebuilding
/// or disposing it, so the [IndexedStack] underneath keeps doing its
/// job of preserving each tab's state. A plain [AnimatedSwitcher]
/// can't be used here since it would swap the whole subtree (and its
/// state) on every tab change instead of just cross-fading it.
class _TabFade extends StatefulWidget {
  const _TabFade({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_TabFade> createState() => _TabFadeState();
}

class _TabFadeState extends State<_TabFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
    value: 1,
  );

  @override
  void didUpdateWidget(covariant _TabFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: widget.child,
    );
  }
}
