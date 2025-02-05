import 'package:cupertino_sidebar/src/collapsible.dart';
import 'package:flutter/cupertino.dart';

/// A iOS-style [CupertinoSidebar] section.
///
/// Used to group [SidebarDestination]s in a [CupertinoSidebar].
///
/// [SidebarSection]s can be expanded to reveal more destinations.
/// Although [SidebarSection] does not act as a destination itself.
class SidebarSection extends StatefulWidget {
  const SidebarSection({
    required this.label,
    required this.children,
    super.key,
    this.isExpanded,
    this.onPressed,
    this.trailing,
  });

  /// Creates a copy of [section], but replaces its children with [children].
  factory SidebarSection.wrapChildren({
    required List<Widget> children,
    required SidebarSection section,
  }) {
    return SidebarSection(
      label: section.label,
      isExpanded: section.isExpanded,
      onPressed: section.onPressed,
      trailing: section.trailing,
      children: children,
    );
  }

  /// The label for the section.
  final String label;

  /// The widget to display after the [label].
  ///
  /// By default, this is a disclosure button that toggles the [isExpanded]
  /// state.
  final Widget? trailing;

  /// The children of the section.
  ///
  /// Typically a list of [SidebarDestination]s.
  final List<Widget> children;

  /// Whether the section is expanded.
  ///
  /// If this is null, the expansion state will be managed internally.
  final bool? isExpanded;

  /// Called when the section is pressed.
  ///
  /// If this is null, the expansion state will be managed internally.
  final void Function({bool isExpanded})? onPressed;

  @override
  State<SidebarSection> createState() => _SidebarSectionState();
}

class _SidebarSectionState extends State<SidebarSection> {
  bool _isExpanded = true;
  @override
  Widget build(BuildContext context) {
    final sectionStyle = CupertinoTheme.of(context).textTheme.textStyle.copyWith(
          fontWeight: FontWeight.w600,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
          fontSize: 18,
        );

    final border = widget.isExpanded ?? _isExpanded
        ? BorderSide.none
        : BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.33,
          );
    return Semantics(
      expanded: widget.isExpanded ?? _isExpanded,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(bottom: border),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (widget.onPressed != null)
                      widget.onPressed!(isExpanded: !_isExpanded);
                    else
                      setState(() => _isExpanded = !_isExpanded);
                  },
                  child: Row(
                    children: [
                      DefaultTextStyle(
                        style: sectionStyle,
                        child: Text(widget.label),
                      ),
                      const Spacer(),
                      widget.trailing ??
                          CupertinoAnimatedChevron(
                            isExpanded: widget.isExpanded ?? _isExpanded,
                          ),
                    ],
                  ),
                ),
              ),
            ),
            CupertinoCollapsible(
              isExpanded: widget.isExpanded ?? _isExpanded,
              child: Column(
                children: widget.children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that rotates when the [isExpanded] state changes.
class CupertinoAnimatedChevron extends StatelessWidget {
  /// Creates a [CupertinoAnimatedChevron].
  const CupertinoAnimatedChevron({
    required this.isExpanded,
    super.key,
    this.child,
  });

  /// Whether the chevron is expanded.
  final bool isExpanded;

  /// The child of the widget.
  ///
  /// By default, this is a chevron icon.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0.25 : 0,
      duration: kCupertinoCollapsibleAnimationDuration,
      curve: kCupertinoCollapsibleAnimationCurve,
      child: child ??
          const Icon(
            CupertinoIcons.chevron_right,
            size: 17,
          ),
    );
  }
}
