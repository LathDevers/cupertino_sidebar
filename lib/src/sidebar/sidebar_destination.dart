import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:cupertino_sidebar/src/destination_info.dart';
import 'package:flutter/cupertino.dart';

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
    this.selectedIcon,
    this.trailing,
    this.subtitle,
    this.onTap,
  });

  /// Indicates whether this destination is selected.
  ///
  /// If [isSelected] is `null`, selection state will be determined by the
  /// destination's index in the [CupertinoSidebar].
  final bool? isSelected;

  /// The icon to display before the label.
  final Widget? icon;

  /// The icon displayed before the label when the destination is selected.
  ///
  /// If [selectedIcon] is `null`, [icon] will be used for both states.
  final Widget? selectedIcon;

  /// The label to display.
  ///
  /// Typically a [Text].
  final Widget label;

  /// An optional subtitle displayed below the [label].
  ///
  /// Typically a [Text].
  final Widget? subtitle;

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
      if ((isSelected ?? false) || (info?.isSelected ?? false))
        WidgetState.selected,
    };

    bool selected() => selectedState.contains(WidgetState.selected);

    final primary = CupertinoTheme.of(context).primaryColor;

    // Display the appropriate icon based on the selection state.
    final effectiveIcon = selected() ? selectedIcon ?? icon : icon;

    final typography = CupertinoTheme.of(context).textTheme;

    final effectiveTextStyle = selected()
        ? typography.textStyle.copyWith(
            color: CupertinoSidebarTextColor(context).resolve(selectedState),
            fontWeight: FontWeight.w600,
          )
        : typography.textStyle;

    final effectiveDetailTextStyle = typography.textStyle.copyWith(
      color: CupertinoColors.secondaryLabel.resolveFrom(context),
    );

    final effectiveSubtitleTextStyle = typography.textStyle.copyWith(
      fontSize: 13,
      letterSpacing: -0.08,
      color: CupertinoColors.secondaryLabel.resolveFrom(context),
    );

    final effectiveBackgroundColor =
        CupertinoSidebarFillColor(context).resolve(selectedState);

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
                  color: CupertinoColors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                if (effectiveIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconTheme(
                      data: IconThemeData(color: primary),
                      child: effectiveIcon,
                    ),
                  ),
                if (subtitle == null)
                  DefaultTextStyle(
                    style: effectiveTextStyle,
                    child: label,
                  ),
                if (subtitle != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultTextStyle(
                        style: effectiveTextStyle,
                        child: label,
                      ),
                      // TODO: Adjust padding if needed for subtitle alignment.
                      DefaultTextStyle(
                        style: effectiveSubtitleTextStyle,
                        child: subtitle!,
                      ),
                    ],
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
