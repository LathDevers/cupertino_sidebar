import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:cupertino_sidebar/src/destination_info.dart';
import 'package:cupertino_sidebar/src/util/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// The color of the cupertino floating tab bar pill.
const kFloatingTabBarPillColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(255, 255, 255, 1),
  darkColor: Color.fromRGBO(255, 255, 255, 0.07),
);

/// A iPadOS-style floating tab bar.
///
/// A floating tab bar is a tab bar that is displayed near the top of the
/// screen, above all other content.
///
/// <img src="https://docs-assets.developer.apple.com/published/9b9a89b3054e378850b30d58483e6169/ipad-tab-bar-music-app@2x.png" width="500">
///
/// The [tabs] are a list of typically [CupertinoFloatingTab]
/// widgets to be displayed as the different tabs.
///
/// If a [TabController] is not provided, then a [DefaultTabController]
/// ancestor must be provided instead.
///
/// The tab controller's [TabController.length] must equal the
/// length of the [tabs] length.
///
/// See also:
/// - [CupertinoFloatingTab] a tab in the floating tab bar.
/// - [CupertinoSidebar] a iOS-style sidebar.
/// - [Apple Design Documentation](https://developer.apple.com/design/human-interface-guidelines/tab-bars)
class CupertinoFloatingTabBar extends StatefulWidget {
  /// Creates a iPadOS-style [CupertinoFloatingTabBar].
  ///
  /// The length of the [tabs] argument must match the [controller]'s
  /// [TabController.length].
  ///
  /// If a [TabController] is not provided,
  /// then there must be a [DefaultTabController] ancestor.
  const CupertinoFloatingTabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.backgroundColor,
    this.isVibrant = false,
    this.onDestinationSelected,
    this.materialStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(9999)),
  });

  /// The tabs to display in the floating tab bar.
  ///
  /// Typically a list of two or more [CupertinoFloatingTab] widgets.
  final List<Widget> tabs;

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of
  /// [DefaultTabController.of] will be used.
  final TabController? controller;

  /// The background color of the floating tab bar.
  ///
  /// If this is null, then [CupertinoColors.tertiarySystemFill] is used.
  ///
  /// When [isVibrant] is true, the color is ignored and a [CupertinoMaterial]
  /// is rendered instead.
  final Color? backgroundColor;

  /// Wether the floating tab bar has a vibrant appearance using a material
  /// instead of a solid color.
  final bool isVibrant;

  /// The border radius of the floating tab bar.
  ///
  /// Defaults to [BorderRadius.circular(9999)].
  final BorderRadiusGeometry borderRadius;

  /// Called when one of the tabs is selected.
  ///
  /// This is called after any drag gesture has finished.
  final ValueChanged<int>? onDestinationSelected;

  /// The material style to use when [isVibrant] is true.
  ///
  /// Uses [CupertinoMaterialStyle.thin] when null.
  final CupertinoMaterialStyle? materialStyle;

  @override
  State<CupertinoFloatingTabBar> createState() =>
      _CupertinoFloatingTabBarState();
}

class _CupertinoFloatingTabBarState extends State<CupertinoFloatingTabBar> {
  late List<GlobalKey> _tabKeys;

  late TabController _controller;

  final ValueNotifier<bool> _isDragging = ValueNotifier(false);

  late List<double> _widths;

  @override
  void initState() {
    _initializeTabKeys();

    super.initState();
  }

  void _initializeTabKeys() {
    _tabKeys = widget.tabs.map((_) => GlobalKey()).toList();
  }

  @override
  void didUpdateWidget(CupertinoFloatingTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabs != widget.tabs) {
      _initializeTabKeys();
    }
  }

  void _onDrag(DragUpdateDetails details) {
    final pos = details.localPosition.dx;
    final index = _getClosestIndex(pos, _widths);
    if (_controller.index != index) {
      _controller.animateTo(
        index,
        // Eyeballed value to make it feel snappy
        curve: Curves.easeInOutCubicEmphasized,
      );
    }
  }

  int _getClosestIndex(double pos, List<double> widths) {
    var cumulativeWidth = 0.0;
    for (var i = 0; i < widths.length; i++) {
      cumulativeWidth += widths[i];
      if (pos < cumulativeWidth) return i;
    }
    return widths.length - 1;
  }

  List<double> _computeWidths() {
    return _tabKeys.map((key) {
      final box = key.currentContext!.findRenderObject()! as RenderBox;
      return box.size.width;
    }).toList();
  }

  void _updateIndex([int? index]) {
    widget.onDestinationSelected?.call(index ?? _controller.index);
  }

  // ignore: use_setters_to_change_properties
  void _toggleDragging(bool dragging) {
    _isDragging.value = dragging;
  }

  List<Widget> _buildTabs() {
    return List<Widget>.generate(
      widget.tabs.length,
      (index) => KeyedSubtree(
        key: _tabKeys[index],
        child: ConditionalListenableBuilder<TabController>(
          listenable: _controller,
          buildWhen: () {
            // Avoid unnecessary rebuilding
            return (index == _controller.index ||
                    index == _controller.previousIndex) &&
                _controller.indexIsChanging;
          },
          builder: (context, child) {
            return CupertinoDestinationInfo(
              index: index,
              selectedIndex: _controller.index,
              totalNumberOfDestinations: widget.tabs.length,
              onPressed: () {
                _updateIndex(index);
                _controller.animateTo(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastEaseInToSlowEaseOut,
                );
              },
              child: child!,
            );
          },
          child: widget.tabs[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller = widget.controller ?? DefaultTabController.of(context);

    assert(
      _controller.length == widget.tabs.length,
      'tabs.length must be equal to controller.length',
    );

    final effectivePillDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      color: kFloatingTabBarPillColor.resolveFrom(context),
      boxShadow: [
        BoxShadow(
          color: CupertinoColors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 2),
        ),
      ],
    );

    final effectiveBackgroundColor = widget.isVibrant
        ? const Color(0x00000000)
        : widget.backgroundColor ??
            CupertinoColors.tertiarySystemFill.resolveFrom(context);

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: RepaintBoundary(
        child: ColoredBox(
          color: effectiveBackgroundColor,
          child: CupertinoMaterial(
            style: CupertinoMaterialStyle.thin,
            isActive: widget.isVibrant,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Stack(
                children: [
                  _PositionBuilder(
                    decoration: effectivePillDecoration,
                    tabKeys: _tabKeys,
                    controller: _controller,
                    isDragging: _isDragging,
                  ),
                  GestureDetector(
                    onHorizontalDragStart: (details) {
                      _widths = _computeWidths();
                      _toggleDragging(true);
                    },
                    onHorizontalDragUpdate: _onDrag,
                    onHorizontalDragEnd: (details) {
                      _updateIndex();
                      _toggleDragging(false);
                    },
                    onTapDown: (details) => _toggleDragging(true),
                    onTapUp: (details) => _toggleDragging(false),
                    onTapCancel: () => _toggleDragging(false),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildTabs(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PositionBuilder extends StatefulWidget {
  const _PositionBuilder({
    required this.tabKeys,
    required this.controller,
    required this.decoration,
    required this.isDragging,
  });

  final List<GlobalKey> tabKeys;
  final TabController controller;
  final BoxDecoration decoration;
  final ValueNotifier<bool> isDragging;

  @override
  State<_PositionBuilder> createState() => _PositionBuilderState();
}

class _PositionBuilderState extends State<_PositionBuilder> {
  List<double> _widths = [];

  @override
  void initState() {
    super.initState();
    _updateWidths();
  }

  @override
  void didUpdateWidget(covariant _PositionBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabKeys != widget.tabKeys) {
      _updateWidths();
    }
  }

  void _updateWidths() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _widths = _computeWidths();
      });
    });
  }

  List<double> _computeWidths() {
    return widget.tabKeys.map((key) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      return box?.size.width ?? 0.0;
    }).toList();
  }

  double getPosition(double index) {
    var position = 0.0;
    final wholeIndex = index.floor(); // Get the integer part of the index
    final fractionalIndex =
        index - wholeIndex; // Get the fractional part of the index

    // Add up the widths of the widgets up to the whole index
    for (var i = 0; i < wholeIndex && i < _widths.length; i++) {
      position += _widths[i];
    }

    // Add the fractional part of the next widget's width, if it exists
    if (wholeIndex < _widths.length) {
      position += _widths[wholeIndex] * fractionalIndex;
    }

    return position;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller.animation!,
      builder: (context, child) {
        return Positioned(
          left: getPosition(widget.controller.animation!.value),
          child: child!,
        );
      },
      child: ConditionalListenableBuilder<TabController>(
        listenable: widget.controller,
        // Prevent rebuilding twice when the index changes
        buildWhen: () {
          return widget.controller.indexIsChanging;
        },
        builder: (context, child) {
          final width =
              _widths.isNotEmpty ? _widths[widget.controller.index] : 0.0;

          if (width == 0) return const SizedBox();

          return _PressIn(
            isPressed: widget.isDragging,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubicEmphasized,
              transformAlignment: Alignment.center,
              width: width,
              height: 33,
              decoration: widget.decoration,
            ),
          );
        },
      ),
    );
  }
}

class _PressIn extends StatefulWidget {
  const _PressIn({
    required this.isPressed,
    required this.child,
  });

  final Widget child;
  final ValueNotifier<bool> isPressed;

  @override
  State<_PressIn> createState() => __PressInState();
}

class __PressInState extends State<_PressIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    widget.isPressed.addListener(_listener);
  }

  void _listener() {
    if (widget.isPressed.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.isPressed.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(begin: 1, end: 0.93).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
