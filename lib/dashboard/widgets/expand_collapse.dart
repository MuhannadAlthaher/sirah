import 'package:flutter/material.dart';

/// Expands/collapses [child] with a slide-down-and-fade.
///
/// Unlike [AnimatedCrossFade] (which stacks the expanded and
/// collapsed content on top of each other for the whole transition,
/// even though the collapsed side here was always empty), this only
/// ever builds [child] itself and animates its own size/opacity — no
/// second, invisible tree mounted alongside it.
class ExpandCollapse extends StatefulWidget {
  const ExpandCollapse({
    super.key,
    required this.expanded,
    required this.child,
  });

  final bool expanded;
  final Widget child;

  @override
  State<ExpandCollapse> createState() => _ExpandCollapseState();
}

class _ExpandCollapseState extends State<ExpandCollapse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    value: widget.expanded ? 1 : 0,
  );
  late final Animation<double> _curved = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  @override
  void didUpdateWidget(covariant ExpandCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != oldWidget.expanded) {
      if (widget.expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizeTransition(
        sizeFactor: _curved,
        axisAlignment: -1,
        child: FadeTransition(opacity: _curved, child: widget.child),
      ),
    );
  }
}
