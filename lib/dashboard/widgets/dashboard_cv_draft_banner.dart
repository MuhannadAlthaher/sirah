import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/open_cv_builder.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A banner offering to resume an in-progress CV Builder draft — kept
/// entirely separate from "My CVs" below it, since a draft isn't a
/// finished CV. Hidden entirely (including its own spacing) when
/// there's no draft.
///
/// Every size is a fraction of the banner's own available width, so
/// it scales with the screen instead of relying on fixed pixel
/// values.
class DashboardCvDraftBanner extends StatelessWidget {
  const DashboardCvDraftBanner({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DashboardBloc, DashboardState, CvBuilderState?>(
      selector: (state) => state.cvDraft,
      builder: (context, draft) {
        if (draft == null) return const SizedBox.shrink();

        final padding = width * 0.05;
        final l10n = context.l10n;
        final radius = padding * 0.6;

        return Padding(
          padding: EdgeInsets.only(bottom: padding * 1.4),
          child: Material(
            color: context.palette.accentSoft,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: () => openCvBuilder(context, resumeFrom: draft),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(padding * 0.7),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.palette.accent.withValues(alpha: 0.35),
                  ),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_note,
                      color: context.palette.accent,
                      size: width * 0.09,
                    ),
                    SizedBox(width: padding * 0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.cvContinueDraft,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: padding * 0.1),
                          Text(
                            '${draft.draftName(l10n)} • '
                            '${draft.draftProgressLabel(l10n)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: context.palette.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.read<DashboardBloc>().add(
                        const DashboardCvDraftDiscarded(),
                      ),
                      tooltip: l10n.cvDiscard,
                      icon: Icon(
                        Icons.close,
                        color: context.palette.textMuted,
                        size: width * 0.055,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
