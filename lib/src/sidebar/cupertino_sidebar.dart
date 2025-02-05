import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:flutter/cupertino.dart';

/// A iOS-style sidebar.
///
/// The [CupertinoSidebar] provides a sidebar typically placed on the leading
/// side of an app's interface, allowing users to navigate between different
/// sections.
///
/// <img alt="Example Sidebar" src="https://docs-assets.developer.apple.com/published/0014d2d0207333d9624513167a69f2b2/ipad-sidebar-music-app@2x.png" width="600">
///
/// The [children] property accepts a list of widgets, often including
/// [SidebarDestination] widgets for individual destinations. When a
/// [SidebarDestination] is selected, [onDestinationSelected] is triggered with
/// the destination’s index, allowing for tracking the selected destination.
///
/// You can combine [SidebarDestination], [SidebarSection], and
/// [SidebarSectionDestination] widgets to create a navigable structure.
///
/// The indices of the destinations are always calculated from top to bottom.
///
/// ### Example
///
/// The following example creates a sidebar with six destinations, two of which
/// are grouped in a section.
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
/// You can find more information in the [full example](https://github.com/RoundedInfinity/cupertino_sidebar/blob/main/example/lib/main.dart).
///
/// ### Customization
///
/// - [navigationBar] can be added as a sliver widget at the top of the sidebar.
///   Commonly a [SidebarNavigationBar] widget, it provides a header or toolbar.
/// - [backgroundColor] and [border] can be used to style the sidebar.
/// - [isVibrant] provides a material effect for a translucent appearance.
///
/// See also:
/// - [SidebarDestination] one destination in the sidebar.
/// - [SidebarSection] a section that groups destinations together.
/// - [SidebarSectionDestination] a destination that also acts as a section.
class CupertinoSidebar extends StatefulWidget {
  /// Creates a iOS-style [CupertinoSidebar].
  const CupertinoSidebar({
    required this.title,
    required this.children,
    super.key,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor,
    this.maxWidth = 320,
    this.isVibrant = false,
    this.selectedIndex,
    this.onDestinationSelected,
    this.materialStyle,
  });

  /// The material style applied when [isVibrant] is enabled.
  ///
  /// Defaults to [CupertinoMaterialStyle.regular].
  final CupertinoMaterialStyle? materialStyle;

  /// The title of the navigation bar.
  final Widget title;

  /// The leading widget of the navigation bar.
  final Widget? leading;

  /// The trailing widget of the navigation bar.
  final Widget? trailing;

  /// The sidebar's background color.
  ///
  /// Defaults to [CupertinoColors.systemBackground]. When [isVibrant]
  /// is `true`, the background color is overridden with a translucent material.
  final Color? backgroundColor;

  /// The maximum width of the sidebar.
  ///
  /// Defaults to 320 pixels.
  final double maxWidth;

  /// Padding applied to [children].
  final EdgeInsets padding;

  /// A list of widgets displayed within the sidebar.
  ///
  /// Includes [SidebarDestination], [SidebarSection],
  /// [SidebarSectionDestination], and custom widgets.
  final List<Widget> children;

  /// Wether the sidebar has a vibrant appearance using a material instead
  /// of a solid color.
  ///
  /// When `true`, [backgroundColor] is ignored, and the sidebar appears with
  /// a vibrant material-style background.
  final bool isVibrant;

  /// The index of the currently selected [SidebarDestination].
  ///
  /// Must satisfy `0 <= selectedIndex < number of destinations` for valid
  /// selection. An invalid index (e.g., `-1`) or `null` indicates no selection.
  final int? selectedIndex;

  /// Callback triggered when a [SidebarDestination] is selected.
  ///
  /// This should update [selectedIndex] to reflect the selection.
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

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? CupertinoColors.systemBackground.resolveFrom(context);
    final totalNumberOfDestinations = _countDestinations(widget.children);
    var destinationIndex = 0;

    Widget wrapChild(Widget child, int index) {
      return CupertinoDestinationInfo(
        index: index,
        selectedIndex: widget.selectedIndex ?? -1,
        onPressed: () => widget.onDestinationSelected?.call(index),
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

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth,
      ),
      child: CupertinoMaterial(
        style: widget.materialStyle ?? CupertinoMaterialStyle.regular,
        isActive: widget.isVibrant,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.isVibrant ? const Color(0x00000000) : backgroundColor,
            border: Border(
              right: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SidebarNavigationBar(
                  scrollController: _scrollController,
                  color: widget.backgroundColor,
                  title: widget.title,
                  leading: widget.leading,
                  trailing: widget.trailing,
                ),
                SliverPadding(
                  padding: widget.padding,
                  sliver: SliverList.list(
                    children: wrapChildren(widget.children),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _countDestinations(List<Widget> children) {
    return children.fold<int>(0, (count, child) {
      if (child is SidebarDestination) return count + 1;
      if (child is SidebarSectionDestination) return count + 1 + _countDestinations(child.children);
      if (child is SidebarSection) return count + _countDestinations(child.children);
      return count;
    });
  }
}
