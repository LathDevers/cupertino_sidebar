# cupertino_sidebar

With **cupertino_sidebar** you can add iOS-style sidebars and floating tab bars to your app.

## Features

### Cupertino Sidebar

![Cupertino Sidebar]()

A iOS-style sidebar that can be used to navigate through your app.

### Cupertino Floating Tab Bar

![Cupertino Floating Tab Bar]()

A iPadOS-style floating tab bar that can also be used to navigate through your app.

## Usage

### Sidebar

The CupertinoSidebar works very similar to Flutter's  [NavigationDrawer]([https://](https://api.flutter.dev/flutter/material/NavigationDrawer-class.html)). It takes a list of destinations, a selected index and a callback function that is called when a destination is tapped.

```dart
CupertinoSidebar(
  selectedIndex: _selectedIndex,
  onDestinationSelected: (value) {
    setState(() {
      // Update the selected index when a destination is selected.
      _selectedIndex = value;
    });
  },
  children: [
    // index 0
    SidebarDestination(
      icon: Icon(CupertinoIcons.home),
      label: Text('Home'),
    ),
    // index 1
    SidebarDestination(
      icon: Icon(CupertinoIcons.person),
      label: Text('Items'),
    ),
    // index 2
    SidebarDestination(
      icon: Icon(CupertinoIcons.search),
      label: Text('Search'),
    ),
  ],
);
```

The CupertinoSidebar also supports expandable sections to group the destinations.

```dart
...
children: [
    ...
   SidebarSection(
      label: Text('My section'),
      children: [
        SidebarDestination(
          icon: Icon(CupertinoIcons.settings),
          label: Text('Settings'),
        ),
      ],
    ),
]
```

See the [full example]([https://](https://github.com/RoundedInfinity/cupertino_sidebar/blob/main/example/lib/main.dart)) for more details about CupertinoSidebar.

### Floating Tab Bar

The CupertinoFloatingTabBar is managed by a TabController. It takes a list of tabs and an optional callback function that is called when a destination is tapped.

```dart
CupertinoFloatingTabBar(
  onDestinationSelected: (value) {},
  controller: _myTabController,
  tabs: const [
    CupertinoFloatingTab(
      child: Text('Today'),
    ),
    CupertinoFloatingTab(
      child: Text('Library'),
    ),
    CupertinoFloatingTab.icon(
      icon: Icon(CupertinoIcons.search),
    ),
  ],
)
```

See the [full example]([https://](https://github.com/RoundedInfinity/cupertino_sidebar/blob/main/example/lib/tab_bar_example.dart)) for more details about CupertinoFloatingTabBar.

### More examples
- [Creating a collapsible sidebar]([https://](https://github.com/RoundedInfinity/cupertino_sidebar/blob/main/example/lib/collapsible_side_bar.dart))

## TDB

This package is still under development. The following features are planned for the future:

- Tab bar to sidebar transition
- **Adaptive scaffold** that switches between a sidebar and a floating tab bar and a bottom tab bar depending on the screen size
