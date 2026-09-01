import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/custom_section_create_page.dart';
import 'package:sira/cv_builder/custom_section_entries_page.dart';
import 'package:sira/cv_builder/cv_builder_page.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/models/cv_section_order.dart';
import 'package:sira/cv_builder/preview/cv_preview_page.dart';
import 'package:sira/cv_builder/widgets/cv_builder_section_row.dart';
import 'package:sira/cv_builder/widgets/leave_cv_builder_dialog.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';
import 'package:sira/widget/score_ring.dart';

/// What [CvBuilderHubPage] pops with — never a bare [CvBuilderState],
/// so the caller (the dashboard) can never confuse "the user is still
/// working on this" with "this CV is done".
sealed class CvBuilderResult {
  const CvBuilderResult(this.state);

  final CvBuilderState state;
}

/// The user chose "Save & Exit" (or closed) with essentials still
/// missing — not a finished CV, just progress worth remembering. The
/// dashboard must *not* list this alongside real CVs; it's a
/// resumable draft only.
class CvBuilderDraftSaved extends CvBuilderResult {
  const CvBuilderDraftSaved(super.state);
}

/// The user tapped "Finish CV" once every essential section was
/// complete — only this result should ever turn into a real "My CVs"
/// entry.
class CvBuilderCompleted extends CvBuilderResult {
  const CvBuilderCompleted(super.state);
}

/// One section, as shown on the Hub's checklist — a built-in wizard
/// step or a user-created [CustomSection], rendered identically.
class _Section {
  const _Section({
    required this.title,
    required this.isEssential,
    required this.isComplete,
    required this.subtitle,
    required this.onTap,
    this.isInactive = false,
  });

  final String title;
  final bool isEssential;
  final bool isComplete;
  final String subtitle;
  final VoidCallback onTap;

  /// Deactivated by the user — has data, but won't render on the CV.
  /// Only ever true for an optional section (Certifications, or a
  /// custom section).
  final bool isInactive;
}

/// The CV Builder's entry point and "review" screen: an overall
/// progress ring, a "Continue: [next section]" action, and a
/// checklist of every section.
///
/// Personal Information and the Professional Summary always sit in a
/// fixed spot at the top — reordering them would have nothing to
/// affect, since Personal Info is the CV's header (never a "section")
/// and Summary always renders first, right after it. Every other
/// section — Experience, Education, Skills, Certifications, and any
/// section the user built themselves — is drag-reorderable, and that
/// order is exactly the order they render on the CV (see
/// `orderedRenderableSectionKeys`). Optional ones (Certifications, a
/// custom section) can also be deactivated (hidden from the CV,
/// data kept) or removed entirely from their "⋮" menu.
///
/// Tapping any row (or "Continue") opens the linear wizard
/// (`CvBuilderPage`) starting on that exact section; finishing there
/// returns here with the updated state, so the Hub is always what's
/// shown when picking a CV Builder session back up.
///
/// Owns the *one* [CvBuilderBloc] for this whole session (created
/// fresh per visit, or seeded from [initialState] to resume a saved
/// draft). The wizard gets its own separate bloc instance each time
/// it's opened (so its `PageController` always starts on the right
/// page) and hands its final [CvBuilderState] back on pop, which this
/// page's bloc adopts wholesale via [CvBuilderStateReplaced].
class CvBuilderHubPage extends StatelessWidget {
  const CvBuilderHubPage({super.key, this.initialState});

  final CvBuilderState? initialState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CvBuilderBloc(initial: initialState),
      child: const _HubView(),
    );
  }
}

class _HubView extends StatelessWidget {
  const _HubView();

  _Section _personalInfoSection(
    BuildContext context,
    AppLocalizations l10n,
    CvBuilderState state,
  ) => _Section(
    title: l10n.cvStepPersonalInfoTitle,
    isEssential: true,
    isComplete: state.personalInfo.isComplete,
    subtitle: state.personalInfo.isComplete
        ? l10n.cvHubFilledIn
        : l10n.cvHubNeededBeforeExport,
    onTap: () => _openStep(context, 0),
  );

  _Section _summarySection(
    BuildContext context,
    AppLocalizations l10n,
    CvBuilderState state,
  ) => _Section(
    title: l10n.cvStepSummaryTitle,
    isEssential: true,
    isComplete: state.isSummaryComplete,
    subtitle: state.isSummaryComplete
        ? l10n.cvHubSummaryWritten
        : l10n.cvHubNeededBeforeExport,
    onTap: () => _openStep(context, 5),
  );

  /// Every reorderable row keyed by [CvSectionKeys] (or a custom
  /// section's own id) — used both for the drag list and for the
  /// canonical, unreorderable "what's next" progress calculation.
  Map<String, _Section> _reorderableSections(
    BuildContext context,
    AppLocalizations l10n,
    CvBuilderState state,
  ) {
    final map = {
      CvSectionKeys.experience: _Section(
        title: l10n.cvStepExperienceTitle,
        isEssential: true,
        isComplete: state.isExperienceComplete,
        subtitle: state.isExperienceComplete
            ? l10n.cvHubEntriesCount(state.experiences.length)
            : l10n.cvHubNeededBeforeExport,
        onTap: () => _openStep(context, 1),
      ),
      CvSectionKeys.education: _Section(
        title: l10n.cvStepEducationTitle,
        isEssential: true,
        isComplete: state.isEducationComplete,
        subtitle: state.isEducationComplete
            ? l10n.cvHubEntriesCount(state.educations.length)
            : l10n.cvHubNeededBeforeExport,
        onTap: () => _openStep(context, 2),
      ),
      CvSectionKeys.skills: _Section(
        title: l10n.cvStepSkillsTitle,
        isEssential: true,
        isComplete: state.isSkillsComplete,
        subtitle: state.isSkillsComplete
            ? l10n.cvHubSkillsSelected(state.skills.selected.length)
            : l10n.cvHubNeededBeforeExport,
        onTap: () => _openStep(context, 3),
      ),
      CvSectionKeys.certifications: _Section(
        title: l10n.cvStepCertificationsTitle,
        isEssential: false,
        isComplete: state.isCertificationsComplete,
        isInactive: state.deactivatedSections.contains(
          CvSectionKeys.certifications,
        ),
        subtitle:
            state.deactivatedSections.contains(CvSectionKeys.certifications)
            ? l10n.cvSectionInactiveSubtitle
            : state.isCertificationsComplete
            ? l10n.cvHubEntriesCount(state.certifications.length)
            : l10n.cvHubOptionalAddsCredibility,
        onTap: () => _openStep(context, 4),
      ),
    };

    for (final section in state.customSections) {
      map[section.id] = _Section(
        title: section.title,
        isEssential: false,
        isComplete: section.isComplete,
        isInactive: state.deactivatedSections.contains(section.id),
        subtitle: state.deactivatedSections.contains(section.id)
            ? l10n.cvSectionInactiveSubtitle
            : section.isComplete
            ? l10n.cvHubEntriesCount(section.entries.length)
            : l10n.cvHubOptionalAddsCredibility,
        onTap: () => _openCustomSection(context, section.id),
      );
    }

    return map;
  }

  Future<void> _openStep(BuildContext context, int stepIndex) async {
    final bloc = context.read<CvBuilderBloc>();
    final result = await Navigator.of(context).push<CvBuilderState>(
      MaterialPageRoute(
        builder: (_) => CvBuilderPage(
          initialState: bloc.state.copyWith(currentStep: stepIndex),
        ),
      ),
    );
    if (result != null && context.mounted) {
      bloc.add(CvBuilderStateReplaced(result));
    }
  }

  void _openCustomSection(BuildContext context, String sectionId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CvBuilderBloc>(),
          child: CustomSectionEntriesPage(sectionId: sectionId),
        ),
      ),
    );
  }

  Future<void> _addCustomSection(BuildContext context) async {
    final section = await Navigator.of(context).push<CustomSection>(
      MaterialPageRoute(builder: (_) => CustomSectionCreatePage()),
    );
    if (section != null && context.mounted) {
      context.read<CvBuilderBloc>().add(CvBuilderCustomSectionAdded(section));
    }
  }

  void _toggleActive(BuildContext context, String sectionKey) {
    context.read<CvBuilderBloc>().add(
      CvBuilderSectionActiveToggled(sectionKey),
    );
  }

  Future<void> _removeCustomSection(
    BuildContext context,
    String sectionId,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cvCustomSectionDeleteConfirmTitle),
        content: Text(l10n.cvCustomSectionDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: dialogContext.palette.danger,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<CvBuilderBloc>().add(
        CvBuilderCustomSectionDeleted(sectionId),
      );
    }
  }

  void _reorder(
    BuildContext context,
    List<String> currentOrder,
    int oldIndex,
    int newIndex,
  ) {
    // onReorderItem's newIndex already accounts for the removal at
    // oldIndex — unlike the deprecated onReorder, no manual -1 here.
    final order = List<String>.of(currentOrder);
    final moved = order.removeAt(oldIndex);
    order.insert(newIndex, moved);
    context.read<CvBuilderBloc>().add(CvBuilderSectionOrderChanged(order));
  }

  Future<void> _finish(BuildContext context) async {
    final bloc = context.read<CvBuilderBloc>();
    final result = await Navigator.of(context).push<CvPreviewResult>(
      MaterialPageRoute(
        builder: (_) =>
            CvPreviewPage(state: bloc.state, mode: CvPreviewMode.finalReview),
      ),
    );
    if (result == null || !context.mounted) return;

    if (result.templateId != bloc.state.templateId) {
      bloc.add(CvBuilderTemplateChanged(result.templateId));
    }
    if (result.saved) {
      Navigator.of(context).pop(
        CvBuilderCompleted(bloc.state.copyWith(templateId: result.templateId)),
      );
    }
  }

  Future<void> _openPreview(BuildContext context) async {
    final bloc = context.read<CvBuilderBloc>();
    final result = await Navigator.of(context).push<CvPreviewResult>(
      MaterialPageRoute(
        builder: (_) =>
            CvPreviewPage(state: bloc.state, mode: CvPreviewMode.peek),
      ),
    );
    if (result != null &&
        result.templateId != bloc.state.templateId &&
        context.mounted) {
      bloc.add(CvBuilderTemplateChanged(result.templateId));
    }
  }

  Future<void> _handleClose(BuildContext context) async {
    final bloc = context.read<CvBuilderBloc>();
    final choice = await showLeaveCvBuilderDialog(context);
    if (choice == null || !context.mounted) return;

    final result = choice == LeaveCvBuilderChoice.saveAndExit
        ? CvBuilderDraftSaved(bloc.state)
        : null;
    Navigator.of(context).pop(result);
  }

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
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => _handleClose(context),
                            icon: Icon(
                              Icons.close,
                              color: context.palette.textSecondary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              l10n.cvHubTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => _openPreview(context),
                            tooltip: l10n.cvPreviewTitle,
                            icon: Icon(
                              Icons.visibility_outlined,
                              color: context.palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: padding),
                      BlocBuilder<CvBuilderBloc, CvBuilderState>(
                        builder: (context, state) {
                          final personalInfo = _personalInfoSection(
                            context,
                            l10n,
                            state,
                          );
                          final summary = _summarySection(context, l10n, state);
                          final reorderable = _reorderableSections(
                            context,
                            l10n,
                            state,
                          );

                          // Fixed order, independent of the drag list
                          // — purely for "what essential thing is
                          // still missing" progress math.
                          final essentialForProgress = [
                            personalInfo,
                            reorderable[CvSectionKeys.experience]!,
                            reorderable[CvSectionKeys.education]!,
                            reorderable[CvSectionKeys.skills]!,
                            summary,
                          ];
                          final ready = state.isReadyToFinish;
                          final nextIncomplete = essentialForProgress
                              .firstWhere(
                                (s) => !s.isComplete,
                                orElse: () => essentialForProgress.first,
                              );

                          final orderedKeys = orderedSectionKeysForHub(state);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state.targetRole.trim().isNotEmpty) ...[
                                Text(
                                  l10n.cvHubTargetRoleLabel(state.targetRole),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: context.palette.textSecondary,
                                      ),
                                ),
                                SizedBox(height: padding * 0.8),
                              ],
                              _ProgressCard(
                                width: width,
                                padding: padding,
                                state: state,
                                ready: ready,
                                nextSectionTitle: nextIncomplete.title,
                                onAction: ready
                                    ? () => _finish(context)
                                    : nextIncomplete.onTap,
                              ),
                              SizedBox(height: padding * 1.2),
                              Text(
                                l10n.cvHubEssentialHeader,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: context.palette.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              SizedBox(height: padding * 0.5),
                              _SectionCard(
                                width: width,
                                padding: padding,
                                sections: [personalInfo, summary],
                              ),
                              SizedBox(height: padding * 1.2),
                              Text(
                                l10n.cvHubReorderableHeader,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: context.palette.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              SizedBox(height: padding * 0.5),
                              _ReorderableSectionCard(
                                width: width,
                                padding: padding,
                                orderedKeys: orderedKeys,
                                sections: reorderable,
                                onReorderItem: (oldIndex, newIndex) => _reorder(
                                  context,
                                  orderedKeys,
                                  oldIndex,
                                  newIndex,
                                ),
                                onToggleActive: (key) =>
                                    _toggleActive(context, key),
                                onRemoveCustomSection: (key) =>
                                    _removeCustomSection(context, key),
                                isCustomSection: (key) => state.customSections
                                    .any((s) => s.id == key),
                              ),
                              SizedBox(height: padding * 0.6),
                              OutlinedButton(
                                onPressed: () => _addCustomSection(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: context.palette.accent,
                                  side: BorderSide(
                                    color: context.palette.border,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: padding * 0.6,
                                  ),
                                  minimumSize: const Size.fromHeight(0),
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  '+ ${l10n.cvCustomSectionAddSection}',
                                ),
                              ),
                            ],
                          );
                        },
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
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.width,
    required this.padding,
    required this.state,
    required this.ready,
    required this.nextSectionTitle,
    required this.onAction,
  });

  final double width;
  final double padding;
  final CvBuilderState state;
  final bool ready;
  final String nextSectionTitle;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final essentialsDone = state.essentialSectionsComplete;
    final essentialsTotal = CvBuilderState.essentialSectionCount;
    final progressPercent = ((essentialsDone / essentialsTotal) * 100).round();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding * 0.8),
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border.all(color: context.palette.border),
        borderRadius: BorderRadius.circular(padding * 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScoreRing(score: progressPercent, size: width * 0.22),
              SizedBox(width: padding * 0.7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ready
                          ? l10n.cvHubAllEssentialsDone
                          : l10n.cvHubEssentialStepsLeft(
                              essentialsTotal - essentialsDone,
                            ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: padding * 0.15),
                    Text(
                      l10n.cvHubSectionsFilled(
                        state.completedSectionsCount,
                        CvBuilderState.totalSectionCount,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: padding * 0.8),
          PrimaryCtaButton(
            label: ready
                ? l10n.cvHubFinishCv
                : l10n.cvHubContinueLabel(nextSectionTitle),
            icon: ready ? Icons.check : Icons.arrow_forward,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.width,
    required this.padding,
    required this.sections,
  });

  final double width;
  final double padding;
  final List<_Section> sections;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border.all(color: context.palette.border),
        borderRadius: BorderRadius.circular(padding * 0.6),
      ),
      padding: EdgeInsets.symmetric(horizontal: padding * 0.6),
      child: Column(
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            if (i != 0) Divider(height: 1, color: context.palette.border),
            CvBuilderSectionRow(
              displayNumber: i + 1,
              title: sections[i].title,
              subtitle: sections[i].subtitle,
              isComplete: sections[i].isComplete,
              onTap: sections[i].onTap,
            ),
          ],
        ],
      ),
    );
  }
}

/// The drag-reorderable card: Experience/Education/Skills/
/// Certifications and every custom section, in [orderedKeys] order.
/// Dragging any row calls [onReorderItem], which is exactly the order
/// they'll render on the CV. Optional rows (Certifications, a custom
/// section) get a "⋮" menu for deactivating or (custom sections only)
/// removing them entirely.
class _ReorderableSectionCard extends StatelessWidget {
  const _ReorderableSectionCard({
    required this.width,
    required this.padding,
    required this.orderedKeys,
    required this.sections,
    required this.onReorderItem,
    required this.onToggleActive,
    required this.onRemoveCustomSection,
    required this.isCustomSection,
  });

  final double width;
  final double padding;
  final List<String> orderedKeys;
  final Map<String, _Section> sections;
  final void Function(int oldIndex, int newIndex) onReorderItem;
  final ValueChanged<String> onToggleActive;
  final ValueChanged<String> onRemoveCustomSection;
  final bool Function(String key) isCustomSection;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border.all(color: context.palette.border),
        borderRadius: BorderRadius.circular(padding * 0.6),
      ),
      padding: EdgeInsets.symmetric(horizontal: padding * 0.6),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        proxyDecorator: (child, index, animation) => Material(
          color: Colors.transparent,
          elevation: 4,
          borderRadius: BorderRadius.circular(padding * 0.4),
          child: child,
        ),
        itemCount: orderedKeys.length,
        onReorderItem: onReorderItem,
        itemBuilder: (context, index) {
          final key = orderedKeys[index];
          final section = sections[key]!;
          final isOptional = !section.isEssential;

          return Column(
            key: ValueKey(key),
            mainAxisSize: MainAxisSize.min,
            children: [
              if (index != 0) Divider(height: 1, color: context.palette.border),
              CvBuilderSectionRow(
                displayNumber: index + 1,
                title: section.title,
                subtitle: section.subtitle,
                isComplete: section.isComplete,
                isInactive: section.isInactive,
                onTap: section.onTap,
                dragHandle: ReorderableDragStartListener(
                  index: index,
                  child: Icon(
                    Icons.drag_indicator,
                    color: context.palette.textMuted,
                    size: width * 0.055,
                  ),
                ),
                trailingAction: isOptional
                    ? PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.more_vert,
                          color: context.palette.textSecondary,
                          size: width * 0.05,
                        ),
                        onSelected: (action) {
                          switch (action) {
                            case 'toggle':
                              onToggleActive(key);
                            case 'remove':
                              onRemoveCustomSection(key);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'toggle',
                            child: Text(
                              section.isInactive
                                  ? l10n.cvSectionActivate
                                  : l10n.cvSectionDeactivate,
                            ),
                          ),
                          if (isCustomSection(key))
                            PopupMenuItem(
                              value: 'remove',
                              child: Text(
                                l10n.cvSectionRemove,
                                style: TextStyle(color: context.palette.danger),
                              ),
                            ),
                        ],
                      )
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
