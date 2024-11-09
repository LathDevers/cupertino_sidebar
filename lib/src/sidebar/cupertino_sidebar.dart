import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:cupertino_sidebar/src/destination_info.dart';
import 'package:flutter/cupertino.dart';

/// A iOS-style sidebar.
///
/// A sidebar appears on the leading side of a view and lets people
/// navigate between sections in your app.
///
/// <img src="https://docs-assets.developer.apple.com/published/0014d2d0207333d9624513167a69f2b2/ipad-sidebar-music-app@2x.png" width="500">
///
/// The [children] are a list of widgets to be displayed in the sidebar.
///
/// These can be a mixture of any widgets,
/// but there is special handling for [SidebarDestination]s.
/// They are treated as a group and when one is selected,
/// the [onDestinationSelected] is called with the index into the group that
/// corresponds to the selected destination.
///
/// There can also be a combination of [SidebarSection]s and
/// [SidebarSectionDestination]s to further group destinations.
///
/// The indices of the destinations are always calculated from top to bottom.
///
/// [navigationBar] is a sliver widget that is displayed at the top of the
/// sidebar. Typically this is a [SidebarNavigationBar] widget.
///
/// ### Example
///
/// This example shows a sidebar with 6 destinations, two of them are in a
/// section.
/// `_selectedIndex` represents the index of the selected destination.
///
/// ```dart
/// CupertinoSidebar(
///   // The index of the selected destination.
///   selectedIndex: _selectedIndex,
///   onDestinationSelected: (value) {
///     // Do something when a destination is selected.
///     // For example changing the selected index.
///     setState(() {
///       _selectedIndex = value;
///     });
///   },
///   children: const [
///     // 0
///     SidebarDestination(
///       icon: Icon(CupertinoIcons.home),
///       label: Text('Home'),
///     ),
///     // 1
///     SidebarDestination(
///       icon: Icon(CupertinoIcons.person),
///       label: Text('Items'),
///     ),
///     // 2
///     SidebarDestination(
///       icon: Icon(CupertinoIcons.search),
///       label: Text('Search'),
///     ),
///     SidebarSection(
///       label: Text('My section'),
///       children: [
///         // 3
///         SidebarDestination(
///           icon: Icon(CupertinoIcons.settings),
///           label: Text('Settings'),
///         ),
///         // 4
///         SidebarDestination(
///           icon: Icon(CupertinoIcons.person),
///           label: Text('Profile'),
///         ),
///       ],
///     ),
///     // 5
///     SidebarDestination(
///       icon: Icon(CupertinoIcons.mail),
///       label: Text('Messages'),
///     ),
///   ],
/// );
///  ```
///
/// See also:
/// - [SidebarDestination] one destination in the sidebar.
/// - [SidebarSection] a section that groups destinations together.
/// - [SidebarSectionDestination] a destination that also acts as a section.
class CupertinoSidebar extends StatefulWidget {
  /// Creates a iOS-style [CupertinoSidebar].
  const CupertinoSidebar({
    required this.children,
    super.key,
    this.navigationBar,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor,
    this.border,
    this.maxWidth = 320,
    this.isVibrant = false,
    this.selectedIndex,
    this.onDestinationSelected,
    this.materialStyle,
  });

  /// The material style to use when [isVibrant] is true.
  ///
  /// Uses [CupertinoMaterialStyle.regular] when null.
  final CupertinoMaterialStyle? materialStyle;

  /// The navigation bar to display at the top of the sidebar.
  ///
  /// Needs to be a **sliver** widget.
  ///
  /// Typically a [SidebarNavigationBar] widget.
  final Widget? navigationBar;

  /// The background color of the sidebar.
  ///
  /// If this is null, then [CupertinoColors.systemBackground] is used.
  ///
  /// When [isVibrant] is true, the color is ignored and a [CupertinoMaterial]
  /// is rendered instead.
  final Color? backgroundColor;

  /// The border of the sidebar.
  final Border? border;

  /// The maximum width of the sidebar.
  ///
  /// Defaults to 320.
  final double maxWidth;

  /// The padding applied to [children].
  final EdgeInsets padding;

  /// Defines the appearance of the items within the sidebar.
  ///
  /// The list contains may contain: [SidebarDestination], [SidebarSection],
  /// [SidebarSectionDestination] and/or customized widgets.
  final List<Widget> children;

  /// Wether the sidebar has a vibrant appearance using a material instead
  /// of a solid color.
  final bool isVibrant;

  /// The index into destinations for the current selected
  /// [SidebarDestination] or null if no destination is selected.
  ///
  /// A valid [selectedIndex] satisfies 0 <= [selectedIndex] < number of
  /// [SidebarDestination].
  /// For an invalid [selectedIndex] like `-1`, all destinations will appear
  /// unselected.
  final int? selectedIndex;

  /// Called when one of the [SidebarDestination] children is selected.
  ///
  /// This callback usually updates the int passed to [selectedIndex].
  ///
  /// Upon updating [selectedIndex], the [CupertinoSidebar] will be rebuilt.
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<CupertinoSidebar> createState() => _CupertinoSidebarState();
}

class _CupertinoSidebarState extends State<CupertinoSidebar> {
  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget? _buildNavigationBar() {
    final navBar = widget.navigationBar;

    if (navBar is SidebarNavigationBar && navBar.scrollController == null) {
      // Wrap with scroll controller
      return SidebarNavigationBar(
        scrollController: _scrollController,
        title: navBar.title,
        leading: navBar.leading,
        trailing: navBar.trailing,
      );
    }
    return navBar;
  }

  int _countDestinations(List<Widget> children) {
    return children.fold<int>(0, (count, child) {
      if (child is SidebarDestination) return count + 1;
      if (child is SidebarSectionDestination) {
        return count + 1 + _countDestinations(child.children);
      }
      if (child is SidebarSection) {
        return count + _countDestinations(child.children);
      }
      return count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ??
        CupertinoColors.systemBackground.resolveFrom(context);

    final borderColor = CupertinoColors.separator.resolveFrom(context);

    final totalNumberOfDestinations = _countDestinations(widget.children);

    var destinationIndex = 0;

    Widget wrapChild(Widget child, int index) {
      return CupertinoDestinationInfo(
        index: index,
        selectedIndex: widget.selectedIndex ?? -1,
        onPressed: () {
          widget.onDestinationSelected?.call(index);
        },
        totalNumberOfDestinations: totalNumberOfDestinations,
        child: child,
      );
    }

    List<Widget> wrapChildren(List<Widget> children) {
      final wrappedChildren = <Widget>[];

      for (final child in children) {
        if (child is SidebarDestination) {
          wrappedChildren.add(wrapChild(child, destinationIndex++));
        } else if (child is SidebarSectionDestination) {
          // First add the section with current index
          final sectionIndex = destinationIndex++;
          wrappedChildren.add(
            wrapChild(
              SidebarSectionDestination.wrapChildren(
                destination: child,
                // Then wrap children with subsequent indices
                children: wrapChildren(child.children),
              ),
              sectionIndex,
            ),
          );
        } else if (child is SidebarSection) {
          wrappedChildren.add(
            SidebarSection.wrapChildren(
              section: child,
              children: wrapChildren(child.children),
            ),
          );
        } else {
          wrappedChildren.add(child);
        }
      }

      return wrappedChildren;
    }

    final wrappedChildren = wrapChildren(widget.children);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth,
      ),
      child: CupertinoMaterial(
        style: widget.materialStyle ?? CupertinoMaterialStyle.regular,
        isActive: widget.isVibrant,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isVibrant ? const Color(0x00000000) : backgroundColor,
            border: widget.border ??
                Border(
                  right: BorderSide(
                    color: borderColor,
                    width: 0.5,
                  ),
                ),
          ),
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (widget.navigationBar != null) _buildNavigationBar()!,
                SliverPadding(
                  padding: widget.padding,
                  sliver: SliverList.list(
                    children: wrappedChildren,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
