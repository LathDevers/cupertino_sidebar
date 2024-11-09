import 'dart:ui';

import 'package:flutter/cupertino.dart';

/// A navigation bar that is displayed at the top of a [CupertinoSidebar].
class SidebarNavigationBar extends StatefulWidget {
  /// Creates a [SidebarNavigationBar].
  const SidebarNavigationBar({
    required this.title,
    super.key,
    this.leading,
    this.trailing,
    this.scrollController,
  });

  /// The title of the navigation bar.
  final Widget title;

  /// The leading widget of the navigation bar.
  final Widget? leading;

  /// The trailing widget of the navigation bar.
  final Widget? trailing;

  /// The scroll controller of the navigation bar used to apply scroll effects.
  ///
  /// When using this [SidebarNavigationBar], in a [CupertinoSidebar],
  /// this uses the [SCrollController] of the [CupertinoSidebar].
  final ScrollController? scrollController;

  @override
  State<SidebarNavigationBar> createState() => _SidebarNavigationBarState();
}

class _SidebarNavigationBarState extends State<SidebarNavigationBar> {
  /// Maps a value between 0 and 74 to a value between 0 and 1.
  double _mapValue(double value) {
    return clampDouble(value / 74, 0, 1);
  }

  double scrollValue = 0;

  @override
  void initState() {
    super.initState();

    widget.scrollController?.addListener(() {
      final pos = widget.scrollController!.position.pixels;

      final value = _mapValue(pos);
      if (pos < 75) {
        setState(() {
          scrollValue = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color.lerp(
      CupertinoColors.systemBackground.withOpacity(0),
      CupertinoColors.systemBackground.resolveFrom(context),
      scrollValue,
    );
    final borderColor = Color.lerp(
      CupertinoColors.separator.withOpacity(0),
      CupertinoColors.separator.resolveFrom(context),
      scrollValue,
    );

    return CupertinoSliverNavigationBar(
      stretch: true,
      largeTitle: widget.title,
      backgroundColor: backgroundColor,
      leading: widget.leading,
      trailing: widget.trailing,
      automaticallyImplyLeading: false,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
      border: Border(
        bottom: BorderSide(color: borderColor!, width: 0.33),
      ),
    );
  }
}
