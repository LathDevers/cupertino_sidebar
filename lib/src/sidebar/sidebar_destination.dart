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

/// A iOS-style [CupertinoSidebar] destination.
///
/// Displays an icon with a label, for use in [CupertinoSidebar.children].
///
/// When placed inside a [CupertinoSidebar] and [onTap] and [isSelected] are
/// not set, they will be set automatically based on the destination's index
/// in the [CupertinoSidebar].
///
/// See also:
/// - [SidebarSection] used to group destinations together.
/// - [SidebarSectionDestination] used to group destinations together,
///  but also acts as a destination itself.
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

  /// Whether this destination is selected.
  ///
  /// If this is null, [isSelected] will be set automatically based on the
  /// destination's index in the [CupertinoSidebar].
  final bool? isSelected;

  /// The icon to display before the label.
  final Widget? icon;

  /// The icon to display before the label when this destination is selected.
  final Widget? selectedIcon;

  /// The label to display.
  ///
  /// Typically a [Text].
  final Widget label;

  /// The subtitle to display below the label.
  ///
  /// Typically a [Text].
  final Widget? subtitle;

  /// Called when the destination is tapped.
  ///
  /// If this is null, [onTap] will be set automatically based on the
  /// destination's index in the [CupertinoSidebar].
  final void Function()? onTap;

  /// The widget to display after the label.
  ///
  /// Typically a [Text] or [Icon].
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final info = CupertinoDestinationInfo.maybeOf(context);

    final selectedState = <WidgetState>{
      if ((isSelected ?? false) || (info?.isSelected ?? false))
        WidgetState.selected,
    };

    bool selected() => selectedState.contains(WidgetState.selected);

    final primary = CupertinoTheme.of(context).primaryColor;

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
                      //TODO: fix padding for subtitle.
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
