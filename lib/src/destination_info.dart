import 'package:flutter/widgets.dart';

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
    return context
        .dependOnInheritedWidgetOfExactType<CupertinoDestinationInfo>();
  }

  /// The [CupertinoDestinationInfo] from the closest [BuildContext].
  static CupertinoDestinationInfo of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No SidebarDestinationInfo found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant CupertinoDestinationInfo oldWidget) {
    return index != oldWidget.index ||
        totalNumberOfDestinations != oldWidget.totalNumberOfDestinations ||
        onPressed != oldWidget.onPressed;
  }
}
