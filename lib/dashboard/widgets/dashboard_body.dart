import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/dashboard/dashboard_demo_data.dart';
import 'package:sira/dashboard/widgets/dashboard_cover_letters_section.dart';
import 'package:sira/dashboard/widgets/dashboard_cvs_section.dart';
import 'package:sira/dashboard/widgets/dashboard_profile_header.dart';
import 'package:sira/dashboard/widgets/dashboard_quick_actions_section.dart';

/// The dashboard's scrollable layout shell: profile header and the
/// Quick Actions / CVs / Cover Letters sections — each of which reads
/// its own slice of [DashboardBloc] state rather than this widget
/// threading it all through manually.
class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Sections are sized off `width`, so on a wide screen an
        // uncapped width would blow every card up to the point that
        // only one fits on screen at a time. Capping it keeps card
        // sizes sane and centers the column instead.
        final width = constraints.maxWidth.clamp(0, 480).toDouble();
        final padding = width * 0.05;

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocSelector<DashboardBloc, DashboardState, DemoUser>(
                    selector: (state) => state.user,
                    builder: (context, user) =>
                        DashboardProfileHeader(user: user, width: width),
                  ),
                  SizedBox(height: padding * 1.4),
                  DashboardQuickActionsSection(width: width),
                  SizedBox(height: padding * 1.4),
                  DashboardCvsSection(width: width),
                  SizedBox(height: padding * 1.4),
                  DashboardCoverLettersSection(width: width),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
