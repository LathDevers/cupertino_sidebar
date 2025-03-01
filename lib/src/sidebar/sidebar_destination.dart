import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A [WidgetStateColor] that provides the fill color for a [CupertinoSidebar]
/// destination.
class CupertinoSidebarFillColor extends WidgetStateColor {
  /// Creates a [CupertinoSidebarFillColor] that provides the fill color for a
  /// [CupertinoSidebar] destination.
  ///
  /// The [context] parameter is used to resolve the dynamic color values based
  /// on the current theme.
  const CupertinoSidebarFillColor(this.context) : super(0xFFFFFFFF);

  /// This is used to resolve the dynamic color values based on the current
  /// brightness.
  final BuildContext context;

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFFFFFF),
        darkColor: Color.fromRGBO(142, 142, 147, 0.25),
      ).resolveFrom(context);
    }
    return const Color(0x00000000);
  }
}

/// A [WidgetStateColor] that provides the text color for a [CupertinoSidebar]
/// destination.
class CupertinoSidebarTextColor extends WidgetStateColor {
  /// Creates a [CupertinoSidebarTextColor] that provides the text color for a
  /// [CupertinoSidebar] destination.
  ///
  /// The [context] parameter is used to resolve the dynamic color values based
  /// on the current theme.
  const CupertinoSidebarTextColor(this.context) : super(0xFFFFFFFF);

  /// This is used to resolve the dynamic color values based on the current
  /// theme.
  final BuildContext context;

  @override
  Color resolve(Set<WidgetState> states) {
    final theme = CupertinoTheme.of(context);
    if (states.contains(WidgetState.selected)) {
      return CupertinoDynamicColor.withBrightness(
        color: theme.primaryColor,
        darkColor: CupertinoColors.label.resolveFrom(context),
      ).resolveFrom(context);
    }
    return CupertinoColors.label.resolveFrom(context);
  }
}

/// A configurable, iOS-style destination for use within a [CupertinoSidebar].
///
/// [SidebarDestination] displays an icon, label, optional subtitle, and
/// optional trailing widget, representing an individual destination or
/// navigation option in a [CupertinoSidebar].
///
/// When used within a [CupertinoSidebar], the [isSelected] and [onTap]
/// properties will be automatically set based on the destination's position
/// in the sidebar, if not explicitly provided.
///
///
/// ### Example:
/// ```dart
/// CupertinoSidebar(
///   children: [
///     SidebarDestination(
///       icon: Icon(CupertinoIcons.home),
///       label: Text("Home"),
///       onTap: () => print("Home tapped"),
///     ),
///     SidebarDestination(
///       icon: Icon(CupertinoIcons.settings),
///       label: Text("Settings"),
///     ),
///   ],
/// )
/// ```
///
/// See also:
/// - [SidebarSection], for grouping destinations.
/// - [SidebarSectionDestination], which can serve as both a group header and a
///   selectable destination.
class SidebarDestination extends StatelessWidget {
  /// Creates a iOS-style [SidebarDestination].
  const SidebarDestination({
    required this.label,
    super.key,
    this.isSelected,
    this.icon,
    this.iconColor = CupertinoColors.systemBlue,
    this.trailing,
    this.onTap,
  });

  /// Indicates whether this destination is selected.
  ///
  /// If [isSelected] is `null`, selection state will be determined by the
  /// destination's index in the [CupertinoSidebar].
  final bool? isSelected;

  /// The icon to display before the label.
  final IconData? icon;

  final Color iconColor;

  /// The label to display.
  final String label;

  /// The callback invoked when the destination is tapped.
  ///
  /// If [onTap] is `null`, it will default to a callback provided by the
  /// enclosing [CupertinoSidebar], if available.
  final void Function()? onTap;

  /// An optional widget displayed after the label.
  ///
  /// This can be used to display an icon or other supplementary information
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final info = CupertinoDestinationInfo.maybeOf(context);

    // Determine selection state, prioritizing explicit [isSelected] or sidebar
    // context.
    final selectedState = <WidgetState>{
      if ((isSelected ?? false) || (info?.isSelected ?? false)) WidgetState.selected,
    };

    bool selected() => selectedState.contains(WidgetState.selected);

    final typography = CupertinoTheme.of(context).textTheme;

    final effectiveTextStyle = selected()
        ? typography.textStyle.copyWith(
            color: CupertinoSidebarTextColor(context).resolve(selectedState),
            fontWeight: FontWeight.w600,
          )
        : typography.textStyle.copyWith(
            color: Theme.of(context).colorScheme.primary,
          );

    final effectiveDetailTextStyle = typography.textStyle.copyWith(
      color: CupertinoColors.secondaryLabel.resolveFrom(context),
    );

    final effectiveBackgroundColor = CupertinoSidebarFillColor(context).resolve(selectedState);

    // Accessibility label for screen readers.

    final localizations = CupertinoLocalizations.of(context);
    final semanticsLabel = info != null
        ? localizations.tabSemanticsLabel(
            tabIndex: info.index + 1,
            tabCount: info.totalNumberOfDestinations,
          )
        : null;

    return Semantics(
      container: true,
      label: semanticsLabel,
      selected: selected(),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap ?? info?.onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              if (selected())
                BoxShadow(
                  color: CupertinoColors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: iconColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 17,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                DefaultTextStyle(
                  style: effectiveTextStyle,
                  child: Text(label),
                ),
                const Spacer(),
                if (trailing != null)
                  DefaultTextStyle(
                    style: effectiveDetailTextStyle,
                    child: trailing!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that provides information about the destination in a
/// [CupertinoSidebar] or [CupertinoFloatingTabBar].
class CupertinoDestinationInfo extends InheritedWidget {
  /// Creates a [CupertinoDestinationInfo] widget.
  const CupertinoDestinationInfo({
    required super.child,
    required this.index,
    required this.selectedIndex,
    required this.totalNumberOfDestinations,
    required this.onPressed,
    super.key,
  });

  /// The index of this destination.
  final int index;

  /// The index of the currently selected destination.
  final int selectedIndex;

  /// The total number of destinations.
  ///
  /// Used for semantics.
  final int totalNumberOfDestinations;

  /// The callback that is called when this destination is pressed.
  final VoidCallback onPressed;

  /// Whether this destination is selected.
  bool get isSelected => index == selectedIndex;

  /// The [CupertinoDestinationInfo] from the closest [BuildContext].
  static CupertinoDestinationInfo? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CupertinoDestinationInfo>();
  }

  /// The [CupertinoDestinationInfo] from the closest [BuildContext].
  static CupertinoDestinationInfo of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No SidebarDestinationInfo found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant CupertinoDestinationInfo oldWidget) {
    return index != oldWidget.index || totalNumberOfDestinations != oldWidget.totalNumberOfDestinations || onPressed != oldWidget.onPressed;
  }
}
