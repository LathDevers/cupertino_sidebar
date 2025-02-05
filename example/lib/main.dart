import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:example/pages.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: SidebarExample(),
    );
  }
}

class SidebarExample extends StatefulWidget {
  const SidebarExample({super.key});

  @override
  State<SidebarExample> createState() => _SidebarExampleState();
}

class _SidebarExampleState extends State<SidebarExample> {
  // A list of pages to be displayed as the destination content.
  final _pages = const [
    FirstDemoPage(),
    SecondDemoPage(),
    Text('Page 3'),
    Text('Page 4'),
    Text('Page 5'),
    Text('Page 6'),
  ];

  // The index of the currently selected page.
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Row(
        children: [
          CupertinoSidebar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                // Update the selected index when a destination is selected.
                _selectedIndex = value;
              });
            },
            title: const Text('Sidebar'),
            children: const [
              // index 0
              SidebarDestination(
                icon: CupertinoIcons.home,
                label: 'Home',
              ),
              // index 1
              SidebarDestination(
                icon: CupertinoIcons.person,
                label: 'Items',
              ),
              // index 2
              SidebarDestination(
                icon: CupertinoIcons.search,
                label: 'Search',
              ),
              // index 3
              SidebarSection(
                label: 'My section',
                children: [
                  // index 4
                  SidebarDestination(
                    icon: CupertinoIcons.settings,
                    label: 'Settings',
                  ),
                  // index 5
                  SidebarDestination(
                    icon: CupertinoIcons.person,
                    label: 'Profile',
                  ),
                  // A widget that is not a destination.
                  _AddTile(),
                ],
              ),
              // index 6
              SidebarDestination(
                icon: CupertinoIcons.mail,
                label: 'Messages',
              ),
            ],
          ),
          Expanded(
            child: Center(
              // The CupertinoTabTransitionBuilder applies a iOS 18 tab change transition
              // when the destination changes.
              child: CupertinoTabTransitionBuilder(
                child: _pages.elementAt(_selectedIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A tile to add stuff. This is not a destination but can still be
/// placed in the sidebar.
class _AddTile extends StatelessWidget {
  const _AddTile();

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      onTap: () {
        // Do something when the tile is tapped.
      },
      title: const Text('Add Item'),
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: CupertinoColors.secondarySystemFill,
        ),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
