import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/dashboard/widgets/dashboard_body.dart';
import 'package:sira/theme/app_palette.dart';

/// The "Home" tab's content. All state and business logic live in
/// [DashboardBloc] (see lib/dashboard/bloc/), provided by [AppShell]
/// above this tab; this widget only reacts to its one-off feedback
/// messages — the actual layout lives in [DashboardBody] and its
/// per-section widgets.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      body: SafeArea(
        child: BlocListener<DashboardBloc, DashboardState>(
          listenWhen: (previous, current) =>
              current.pendingMessage != null &&
              current.pendingMessage != previous.pendingMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.pendingMessage!)));
            context.read<DashboardBloc>().add(const DashboardMessageShown());
          },
          child: const DashboardBody(),
        ),
      ),
    );
  }
}
