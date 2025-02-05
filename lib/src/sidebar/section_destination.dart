import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:flutter/cupertino.dart';

/// A iOS-style [CupertinoSidebar] section destination.
///
/// Used to group [SidebarDestination]s in a [CupertinoSidebar] but also
/// acts as a destination itself.
///
/// [SidebarSectionDestination]s can be expanded to reveal more destinations.
class SidebarSectionDestination extends StatefulWidget {
  /// Creates a [SidebarSectionDestination].
  ///
  /// Setting [isExpanded], [onExpand], [iSelected] and [onTap] will override
  /// rhe behavior that is inherited from [CupertinoSidebar].
  const SidebarSectionDestination({
    required this.label,
    required this.children,
    super.key,
    this.isSelected,
    this.icon,
    this.trailing,
    this.onTap,
    this.onExpand,
    this.isExpanded,
    this.sectionPadding = const EdgeInsets.only(left: 16),
  });

  /// Creates a copy of [SidebarSectionDestination] but with
  /// different [children].
  factory SidebarSectionDestination.wrapChildren({
    required SidebarSectionDestination destination,
    required List<Widget> children,
  }) {
    return SidebarSectionDestination(
      label: destination.label,
      icon: destination.icon,
      trailing: destination.trailing,
      onTap: destination.onTap,
      onExpand: destination.onExpand,
      isExpanded: destination.isExpanded,
      sectionPadding: destination.sectionPadding,
      children: children,
    );
  }

  /// Whether this destination is selected.
  ///
  /// If this is null, [isSelected] will be set automatically based on the
  /// destination's index in the [CupertinoSidebar].
  final bool? isSelected;

  /// The icon to display before the label.
  final IconData? icon;

  /// The label to display.
  ///
  /// Typically a [Text].
  final String label;

  /// Called when the destination is tapped.
  ///
  /// If this is null, [onTap] will be set automatically based on the
  /// destination's index in the [CupertinoSidebar].
  final void Function()? onTap;

  /// The widget to display after the label.
  ///
  /// Typically a [Text] or [Icon].
  final Widget? trailing;

  /// The children of the section.
  ///
  /// Typically a list of [SidebarDestination]s.
  final List<Widget> children;

  /// Whether the section is expanded.
  ///
  /// If this is null, the expansion state will be managed internally.
  final bool? isExpanded;

  /// The padding to indent the [children].
  final EdgeInsets sectionPadding;

  /// Called when the [trailing] is tapped.
  ///
  /// If this is null, the expansion state will be managed internally.
  final void Function({bool isExpanded})? onExpand;

  @override
  State<SidebarSectionDestination> createState() => _SidebarSectionDestinationState();
}

class _SidebarSectionDestinationState extends State<SidebarSectionDestination> {
  bool _isExpanded = true;

  bool get _expandedState => widget.isExpanded ?? _isExpanded;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SidebarDestination(
          label: widget.label,
          icon: widget.icon,
          isSelected: widget.isSelected,
          onTap: widget.onTap,
          trailing: CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (widget.onExpand != null) {
                widget.onExpand!.call(isExpanded: _expandedState);
              } else {
                // Manage state internally.
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              }
            },
            child: widget.trailing ??
                CupertinoAnimatedChevron(
                  isExpanded: _expandedState,
                ),
          ),
        ),
        CupertinoCollapsible(
          isExpanded: _expandedState,
          child: Padding(
            padding: widget.sectionPadding,
            child: Column(
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}
