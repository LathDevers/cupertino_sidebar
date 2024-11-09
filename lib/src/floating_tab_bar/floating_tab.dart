import 'package:cupertino_sidebar/src/destination_info.dart';
import 'package:flutter/cupertino.dart';

/// A [WidgetStateColor] that provides the color for a [CupertinoFloatingTab].
///
/// The color is determined by the selection state of the tab.
class CupertinoFloatingTabBarColor extends WidgetStateColor {
  /// Creates a [CupertinoFloatingTabBarColor].
  const CupertinoFloatingTabBarColor(this.context) : super(0xFFFFFFFF);

  /// The context to resolve the color from.
  final BuildContext context;

  @override
  Color resolve(Set<WidgetState> states) {
    final primary = CupertinoTheme.of(context).primaryColor;

    if (states.contains(WidgetState.selected)) {
      return CupertinoDynamicColor.withBrightness(
        color: primary,
        darkColor: CupertinoColors.white,
      ).resolveFrom(context);
    }

    return const CupertinoDynamicColor.withBrightness(
      color: Color.fromRGBO(9, 9, 9, 1),
      darkColor: Color.fromRGBO(161, 161, 161, 1),
    ).resolveFrom(context);
  }
}

/// A iPadOS-style [CupertinoFloatingTabBar] tab.
///
/// When [isSelected] is not set, the selection state is determined by the
/// [CupertinoFloatingTabBar] that contains this tab.
class CupertinoFloatingTab extends StatelessWidget {
  /// Creates a [CupertinoFloatingTab].
  ///
  /// When [isSelected] is not set, the selection state is determined by the
  /// [CupertinoFloatingTabBar] that contains this tab.
  const CupertinoFloatingTab({
    required this.child,
    super.key,
    this.isSelected,
  }) : _isIcon = false;

  /// Creates a [CupertinoFloatingTab] with an icon instead
  /// of a text.
  const CupertinoFloatingTab.icon({
    required Widget icon,
    super.key,
    this.isSelected,
  })  : _isIcon = true,
        child = icon;

  /// The widget to display in the tab.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  final bool _isIcon;

  /// Whether the tab is highlighted as selected.
  ///
  /// When not set, the selection state is determined by the nearest
  /// [CupertinoFloatingTabBar] that contains this tab.
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    final info = CupertinoDestinationInfo.maybeOf(context);

    final selectedState = <WidgetState>{
      if ((isSelected ?? false) || (info?.isSelected ?? false))
        WidgetState.selected,
    };

    final effectiveColor =
        CupertinoFloatingTabBarColor(context).resolve(selectedState);

    final localizations = CupertinoLocalizations.of(context);

    final semanticsLabel = info != null
        ? localizations.tabSemanticsLabel(
            tabIndex: info.index + 1,
            tabCount: info.totalNumberOfDestinations,
          )
        : null;

    return Semantics(
      container: true,
      selected: selectedState.contains(WidgetState.selected),
      label: semanticsLabel,
      child: SizedBox(
        height: 33,
        width: _isIcon ? 56 : null,
        child: Padding(
          padding: _isIcon
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 14),
          child: Center(
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: info!.onPressed,
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: -0.23,
                  fontWeight: FontWeight.w600,
                  color: effectiveColor,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: effectiveColor,
                    size: 20,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
