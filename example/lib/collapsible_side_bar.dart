import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:example/pages.dart';
import 'package:flutter/cupertino.dart';

/// This example shows how to use the [CupertinoSidebar] and [CupertinoSidebarCollapsible].
class CollapsibleSidebarExample extends StatefulWidget {
  const CollapsibleSidebarExample({super.key});

  @override
  State<CollapsibleSidebarExample> createState() => _CollapsibleSidebarExampleState();
}

class _CollapsibleSidebarExampleState extends State<CollapsibleSidebarExample> {
  final _pages = const [
    FirstDemoPage(),
    SecondDemoPage(),
    Text('Page 3'),
    Text('Page 4'),
    Text('Page 5'),
  ];

  int _selectedIndex = 0;

  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // The "show sidebar" button is placed in a Stack to ensure that it will not move during the transition.
      // This mimics the iOS behavior of the sidebar.
      child: Stack(
        children: [
          Row(
            children: [
              // A widget that applies a collapse effect.
              CupertinoSidebarCollapsible(
                isExpanded: isExpanded,
                child: CupertinoSidebar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                  title: const Text('Sidebar'),
                  children: const [
                    SidebarDestination(
                      icon: CupertinoIcons.home,
                      label: 'Home',
                    ),
                    SidebarDestination(
                      icon: CupertinoIcons.person,
                      label: 'Items',
                    ),
                    SidebarDestination(
                      icon: CupertinoIcons.search,
                      label: 'Search',
                    ),
                    SidebarSection(
                      label: 'My section',
                      children: [
                        SidebarDestination(
                          icon: CupertinoIcons.settings,
                          label: 'Settings',
                        ),
                        SidebarDestination(
                          icon: CupertinoIcons.person,
                          label: 'Profile',
                        ),
                        // A widget that is not a destination.
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: CupertinoTabTransitionBuilder(
                    child: _pages.elementAt(_selectedIndex),
                  ),
                ),
              ),
            ],
          ),
          // A button to show/hide the sidebar.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: const Icon(CupertinoIcons.sidebar_left),
              ),
            ),
          )
        ],
      ),
    );
  }
}
